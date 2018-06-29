# frozen_string_literal: true

require_relative 'document_files'

module Cab
  module Tasks
    class Transfer
      # Пространство имён классов объектов, которые импортируют записи
      module Importers
        # Класс объектов, импортирующих записи физических лиц вместе с записями
        # документов, удостоверяющих личность
        class Individual
          include DocumentFiles

          # Инициализирует экземпляр класса
          # @param [Hash] ecm_person
          #   ассоциативный массив с полями исходной записи физического лица
          # @param [Cab::Tasks::Transfer::Cabinet] cabinet
          #   объект доступа к данным исходной базы данных
          def initialize(ecm_person, cabinet)
            @ecm_person = ecm_person
            @cabinet = cabinet
          end

          # Импортирует запись физического лица вместе с записями документов,
          # удостоверяющих личность. В случае успеха возвращает пустой список.
          # В случае неудачи возвращает список с описаниями проблем.
          # @return [Array<String>]
          #   результирующий список
          def import
            individual_fields = load_individual_fields
            documents = load_documents
            result = check_import(individual_fields, documents)
            return result if result.size.positive?
            Sequel::Model.db.transaction do
              import_individual(individual_fields)
              import_documents(documents)
            end
            []
          end

          private

          # Ассоциативный массив с полями исходной записи физического лица
          # @return [Hash]
          #   ассоциативный массив с полями исходной записи физического лица
          attr_reader :ecm_person

          # Объект доступа к данным исходной базы данных
          # @return [Cab::Tasks::Transfer::Cabinet]
          #   объект доступа к данным исходной базы данных
          attr_reader :cabinet

          # Названия полей, извлекаемых из ассоциативного массива полей
          # исходной записи физического лица
          SLICE_FIELDS = %i[id middle_name birth_place sex].freeze

          # Возвращает ассоциативный массив полей импортируемой записи
          # физического лица
          # @return [Hash]
          #   результирующий ассоциативный массив
          def load_individual_fields
            ecm_person.slice(*SLICE_FIELDS).tap do |hash|
              hash[:name]                 = ecm_person[:first_name]
              hash[:surname]              = ecm_person[:last_name]
              hash[:birthday]             = load_birthday
              hash[:citizenship]          = load_citizenship
              hash[:snils]                = load_snils
              hash[:inn]                  = load_inn
              hash[:registration_address] = load_registration_address
              hash[:residence_address]    = load_residence_address
              hash[:agreement]            = load_agreement
              hash[:created_at]           = load_created_at
            end
          end

          # Возвращает строку с датой рождения или `nil`, если дата рождения не
          # указана
          # @return [String]
          #   строка с датой рождения
          # @return [NilClass]
          #   если дата рождения не указана
          def load_birthday
            ecm_person[:birth_date]&.strftime('%F')
          end

          # Возвращает строку с датой создания записи
          # @return [String]
          #   строка с датой рождения
          def load_created_at
            ecm_person[:created_at].strftime('%FT%T')
          end

          # Ассоциативный массив, сопоставляющий значениям поля `foreigner`
          # исходной записи физического лица значения поля `citizenship`
          # импортируемой записи
          CITIZENSHIP = {
            nil   => 'russian',
            true  => 'russian',
            false => 'foreign'
          }.freeze

          # Возвращает значение поля `foreigner` исходной записи физического
          # лица
          # @return [Object]
          #   результирующее значение
          def ecm_person_foreigner
            ecm_person[:foreigner]
          end

          # Возвращает значение поля `citizenship` импортируемой записи
          # физического лица
          # @return [String]
          #   результирующее значение
          def load_citizenship
            CITIZENSHIP[ecm_person[:foreigner]]
          end

          # Формат строки СНИЛС
          SNILS_FORMAT = /^[0-9]{3}-[0-9]{3}-[0-9]{3} [0-9]{2}$/

          # Возвращает строку со СНИЛС в правильном формате или `nil`, если
          # такую строку невозможно извлечь
          # @return [String]
          #   строка со СНИЛС
          # @return [NilClass]
          #   если строку со СНИЛС невозможно извлечь
          def load_snils
            s = ecm_person[:snils] || ecm_person[:name] || return
            return s if SNILS_FORMAT.match?(s)
            s = "#{s[0..2]}-#{s[3..5]}-#{s[6..8]} #{s[9..10]}"
            s if SNILS_FORMAT.match?(s)
          end

          # Формат строки ИНН
          INN_FORMAT = /^[0-9]{12}$/

          # Возвращает строку с ИНН в правильном формате или `nil`, если такую
          # строку невозможно извлечь
          # @return [String]
          #   строка со СНИЛС
          # @return [NilClass]
          #   если строку со СНИЛС невозможно извлечь
          def load_inn
            inn = ecm_person[:inn]
            inn if INN_FORMAT.match?(inn)
          end

          # Возвращает идентификатор исходной записи физического лица
          # @return [String]
          #   идентификатор исходной записи физического лица
          def ecm_person_id
            ecm_person[:id]
          end

          # Возвращает список ассоциативных массивов с информацией об исходных
          # записях документов физического лица
          # @return [Array<Hash>]
          #   результирующий список
          def ecm_documents
            folder_id = ecm_person[:private_folder_id]
            cabinet.ecm_documents[folder_id] || []
          end

          # Возвращает JSON-строку с адресом регистрации физического лица или
          # `nil`, если адрес регистрации не указан
          # @return [String]
          #   результирующая JSON-строка
          # @return [NilClass]
          #   если адрес регистрации не указан
          def load_registration_address
            address = cabinet.ecm_addresses[ecm_person_id]
            address && Oj.dump(address)
          end

          # Возвращает JSON-строку с фактическим адресом проживания физического
          # лица или `nil`, если фактический адрес проживания не указан
          # @return [String]
          #   результирующая JSON-строка
          # @return [NilClass]
          #   если фактический адрес проживания не указан
          def load_residence_address
            address = cabinet.ecm_factual_addresses[ecm_person_id]
            address && Oj.dump(address)
          end

          # URN согласия на обработку персональных данных
          AGREEMENT_URN =
            'urn:metastore:documents.gosuslugi.Dokumenty_lichnogo_xraneniya.'\
            'Soglasie_na_obrabotku_personalnyx_dannyx'

          # Возвращает содержимое файла с согласием на обработку персональных
          # данных или `nil`, если файл не удалось извлечь из файлового
          # хранилища
          # @return [String]
          #   содержимое файла с согласием на обработку персональных данных
          # @return [NilClass]
          #   если файл не удалось извлечь из файлового хранилища
          def load_agreement
            agreement = ecm_documents.find do |doc|
              doc[:schema_urn].start_with?(AGREEMENT_URN)
            end
            storage_key = agreement && agreement[:attachment]
            storage_key && file(storage_key)
          end

          # Возвращает список ассоциативных массивов с информацией о
          # документах, удостоверяющих личность
          # @return [Array<Hash>]
          #   результирующий список
          def load_documents
            ecm_documents.each_with_object([]) do |doc, memo|
              next if malformed_content?(doc)
              body = file(doc[:attachment])
              memo << load_document(doc, body) unless body.nil?
            end
          end

          # Типы документов
          DOC_TYPES = Models::IdentityDocument::TYPES.map(&:to_s).to_set.freeze

          # Возвращает, отсутствуют ли у содержимого документа необходимые
          # атрибуты
          # @return [Boolean]
          #   отсутствуют ли у содержимого документа необходимые атрибуты
          def malformed_content?(doc)
            content = doc[:content]
            !DOC_TYPES.include?(content[:type]) ||
              content[:ser].nil? ||
              content[:kemvid].nil? ||
              content[:datavid].nil? ||
              Date.parse(content[:datavid]).nil?
          rescue StandardError
            true
          end

          # Возвращает ассоциативный массив полей импортируемой записи
          # документа
          # @param [Hash] doc
          #   ассоциативный массив с информацией об исходной записи документа
          # @param [String] body
          #   содержимое файла
          # @return [Hash]
          #   результирующий ассоциативный массив
          def load_document(doc, body)
            {
              id:            doc[:id],
              type:          doc[:content][:type],
              number:        doc[:content][:nom],
              series:        doc[:content][:ser],
              issued_by:     doc[:content][:kemvid],
              issue_date:    doc[:content][:datavid],
              content:       body,
              created_at:    doc[:created_at].strftime('%FT%T'),
              individual_id: ecm_person[:id]
            }
          end

          # Ассоциативный массив, в котором названиям полей импортируемой
          # записи физического лица сопоставлены сообщения о том, что эти поля
          # не заполнены
          FIELD_MESSAGES = {
            name:              'не заполнено имя',
            surname:           'не заполнена фамилия',
            birth_place:       'не заполнено место рождения',
            birthday:          'не заполнена дата рождения',
            sex:               'не заполнен пол',
            citizenship:       'не заполнено гражданство',
            residence_address: 'не заполнен адрес проживания',
            agreement:         <<-MESSAGE.squish
              отсутствует информация о соглашении на обработку персональных
              данных
            MESSAGE
          }.freeze

          # Сообщение о том, что отсутствует информация о документах,
          # удостоверяющих личность
          EMPTY_DOCUMENTS_MESSAGE =
            'отсутствует информация о документах, удостоверяющих личность'

          # Возвращает список с информацией о незаполненных полях и
          # отсутствующих документах, удостоверяющих личность
          # @param [Hash] fields
          #   ассоциативный массив полей импортируемой записи
          # @param [Array] documents
          #   список с информацией о документах
          def check_import(fields, documents)
            [].tap do |result|
              FIELD_MESSAGES.each do |field, message|
                result << message if fields[field].nil?
              end
              result << EMPTY_DOCUMENTS_MESSAGE if documents.empty?
            end
          end

          # Создаёт запись физического лица
          # @param [Hash] fields
          #   ассоциативный массив полей импортируемой записи
          def import_individual(fields)
            model = Models::Individual
            model.unrestrict_primary_key
            model.create(fields)
            model.restrict_primary_key
          end

          # Создаёт записи документов, удостоверяющих личность
          # @param [Array<Hash>] documents
          #   список ассоциативных массивов с информацией о документах,
          #   удостоверяющих личность
          def import_documents(documents)
            model = Models::IdentityDocument
            model.unrestrict_primary_key
            documents.each(&model.method(:create))
            model.restrict_primary_key
          end
        end
      end
    end
  end
end
