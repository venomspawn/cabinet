# frozen_string_literal: true

module Cab
  module Tasks
    class Transfer
      module Importers
        # Класс объектов, импортирующих записи организаций
        class Organization
          # Инициализирует экземпляр класса
          # @param [Hash] ecm_person
          #   ассоциативный массив с полями исходной записи заявителя
          # @param [Hash] ecm_org
          #   ассоциативный массив с полями исходной записи организации
          # @param [Cab::Tasks::Transfer::Cabinet] cabinet
          #   объект доступа к данным исходной базы данных
          def initialize(ecm_person, ecm_org, cabinet)
            @ecm_person = ecm_person
            @ecm_org = ecm_org
            @cabinet = cabinet
          end

          # Импортирует запись организации. В случае успеха возвращает пустой
          # список. В случае неудачи возвращает список с описаниями проблем.
          # @return [Array<String>]
          #   результирующий список
          def import
            organization_fields = load_organization_fields
            result = check_import(organization_fields)
            return result if result.size.positive?
            import_organization(organization_fields)
            []
          end

          private

          # Ассоциативный массив с полями исходной записи заявителя
          # @return [Hash]
          #   ассоциативный массив с полями исходной записи заявителя
          attr_reader :ecm_person

          # Ассоциативный массив с полями исходной записи организации
          # @return [Hash]
          #   ассоциативный массив с полями исходной записи организации
          attr_reader :ecm_org

          # Объект доступа к данным исходной базы данных
          # @return [Cab::Tasks::Transfer::Cabinet]
          #   объект доступа к данным исходной базы данных
          attr_reader :cabinet

          # Ассоциативный массив, сопоставляющий названиями полей импортируемой
          # записи юридического лица названия методов, извлекающих значения
          # этих полей
          LOADERS = {
            registration_date: :load_registration_date,
            ogrn:              :load_ogrn,
            inn:               :load_inn,
            kpp:               :load_kpp,
            legal_address:     :load_legal_address,
            actual_address:    :load_actual_address,
            bank_details:      :load_bank_details,
            created_at:        :load_created_at
          }.freeze

          # Возвращает ассоциативный массив полей импортируемой записи
          # организации
          # @return [Hash]
          #   результирующий ассоциативный массив
          def load_organization_fields
            {}.tap do |hash|
              hash[:id]            = ecm_person_id
              hash[:full_name]     = ecm_org[:full_name]
              hash[:short_name]    = ecm_org[:short_name]
              hash[:chief_name]    = ''
              hash[:chief_surname] = ecm_org[:director]
              LOADERS.each { |key, name| hash[key] = send(name) }
            end
          end

          # Возвращает строку с датой регистрации или `nil`, если дата
          # регистрации не указана
          # @return [String]
          #   строка с датой регистрации
          # @return [NilClass]
          #   если дата регистрации не указана
          def load_registration_date
            ecm_org[:registration_date]&.strftime('%F')
          end

          # Возвращает строку с датой создания записи
          # @return [String]
          #   строка с датой рождения
          def load_created_at
            ecm_org[:created_at].strftime('%FT%T')
          end

          # Формат строки ИНН
          INN_FORMAT = /^[0-9]{10}$/

          # Возвращает строку с ИНН в правильном формате или `nil`, если такую
          # строку невозможно извлечь
          # @return [String]
          #   строка с ИНН
          # @return [NilClass]
          #   если строку с ИНН невозможно извлечь
          def load_inn
            inn = ecm_org[:inn]
            inn if INN_FORMAT.match?(inn)
          end

          # Формат строки КПП
          KPP_FORMAT = /^[0-9]{9}$/

          # Возвращает строку с КПП в правильном формате или `nil`, если такую
          # строку невозможно извлечь
          # @return [String]
          #   строка с КПП
          # @return [NilClass]
          #   если строку с КПП невозможно извлечь
          def load_kpp
            kpp = ecm_org[:kpp]
            kpp if KPP_FORMAT.match?(kpp)
          end

          # Формат строки ОГРН
          OGRN_FORMAT = /^[0-9]{13}$/

          # Возвращает строку с ОГРН в правильном формате или `nil`, если такую
          # строку невозможно извлечь
          # @return [String]
          #   строка с ОГРН
          # @return [NilClass]
          #   если строку с ОГРН невозможно извлечь
          def load_ogrn
            ogrn = ecm_org[:ogrn] || ecm_person[:name]
            ogrn if OGRN_FORMAT.match?(ogrn)
          end

          # Возвращает идентификатор исходной записи заявителя
          # @return [String]
          #   идентификатор исходной записи заявителя
          def ecm_person_id
            ecm_person[:id]
          end

          # Возвращает JSON-строку с юридическим адресом организации или `nil`,
          # если юридический адрес не указан
          # @return [String]
          #   результирующая JSON-строка
          # @return [NilClass]
          #   если юридический адрес не указан
          def load_legal_address
            address = cabinet.ecm_addresses[ecm_person_id]
            address && Oj.dump(address)
          end

          # Возвращает JSON-строку с фактическим адресом организации или `nil`,
          # если фактический адрес не указан
          # @return [String]
          #   результирующая JSON-строка
          # @return [NilClass]
          #   если фактический адрес не указан
          def load_actual_address
            address = cabinet.ecm_factual_addresses[ecm_person_id]
            address && Oj.dump(address)
          end

          # Возвращает ассоциативный массив с банковскими данными
          # организации
          # @return [Hash]
          #   результирующий ассоциативный массив
          def load_bank_details
            {
              bik:          ecm_org[:bik],
              account:      ecm_org[:settlement_account],
              corr_account: ecm_org[:correspondent_account],
              name:         ecm_org[:bankname]
            }
          end

          # Ассоциативный массив, в котором названиям полей импортируемой
          # записи организации сопоставлены сообщения о
          # том, что эти поля не заполнены
          FIELD_MESSAGES = {
            full_name:         'не заполнено полное название',
            chief_name:        'не заполнено имя главы',
            chief_surname:     'не заполнена фамилия главы',
            registration_date: 'не заполнена дата регистрации',
            inn:               'не заполнен ИНН',
            kpp:               'не заполнен КПП',
            ogrn:              'не заполнен ОГРН',
            legal_address:     'не заполнен юридический адрес'
          }.freeze

          # Возвращает список с информацией о незаполненных полях
          # @param [Hash] fields
          #   ассоциативный массив полей импортируемой записи
          # @param [Array] documents
          #   список с информацией о документах
          def check_import(fields)
            FIELD_MESSAGES.each_with_object([]) do |(field, message), result|
              result << message if fields[field].nil?
            end
          end

          # Создаёт запись организации
          # @param [Hash] fields
          #   ассоциативный массив полей импортируемой записи
          def import_organization(fields)
            model = Models::Organization
            model.unrestrict_primary_key
            model.create(fields)
            model.restrict_primary_key
          end
        end
      end
    end
  end
end
