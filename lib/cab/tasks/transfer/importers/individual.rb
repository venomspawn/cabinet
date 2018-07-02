# frozen_string_literal: true

require_relative 'document_files'
require_relative 'individual/loaders'

module Cab
  module Tasks
    class Transfer
      # Пространство имён классов объектов, которые импортируют записи
      module Importers
        # Класс объектов, импортирующих записи физических лиц вместе с записями
        # документов, удостоверяющих личность
        class Individual
          include DocumentFiles
          include Loaders

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

          # Возвращает список ассоциативных массивов с информацией об исходных
          # записях документов физического лица
          # @return [Array<Hash>]
          #   результирующий список
          def ecm_documents
            folder_id = ecm_person[:private_folder_id]
            cabinet.ecm_documents[folder_id] || []
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

          # Ассоциативный массив, сопоставляющий названиям полей импортируемой
          # записи документа пути для извлечения данных из структуры исходной
          # записи документа
          DOC_PATHS = {
            id:         %i[id],
            type:       %i[content type],
            number:     %i[content nom],
            series:     %i[content ser],
            issued_by:  %i[content kemvid],
            issue_date: %i[content datavid]
          }.freeze

          # Возвращает ассоциативный массив полей импортируемой записи
          # документа
          # @param [Hash] doc
          #   ассоциативный массив с информацией об исходной записи документа
          # @param [String] body
          #   содержимое файла
          # @return [Hash]
          #   результирующий ассоциативный массив
          def load_document(doc, body)
            hash = {
              content:       body,
              created_at:    doc[:created_at].strftime('%FT%T'),
              individual_id: ecm_person[:id]
            }
            hash.tap { DOC_PATHS.each { |key, p| hash[key] = doc.dig(*p) } }
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
          # @return [Array]
          #   результирующий список
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
