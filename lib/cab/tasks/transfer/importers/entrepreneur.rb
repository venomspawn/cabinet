# frozen_string_literal: true

module Cab
  module Tasks
    class Transfer
      module Importers
        # Класс объектов, импортирующих записи индивидуальных предпринимателей
        class Entrepreneur
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

          # Импортирует запись индивидуального предпринимателя. В случае успеха
          # возвращает пустой список. В случае неудачи возвращает список с
          # описаниями проблем.
          # @return [Array<String>]
          #   результирующий список
          def import
            entrepreneur_fields = load_entrepreneur_fields
            result = check_import(entrepreneur_fields)
            return result if result.size.positive?
            import_entrepreneur(entrepreneur_fields)
            []
          end

          private

          # Ассоциативный массив с полями исходной записи заявителя
          # @return [Hash]
          #   ассоциативный массив с полями исходной записи заявителя
          attr_reader :ecm_person

          # Ассоциативный массив с полями исходной записи индивидуального
          # предпринимателя
          # @return [Hash]
          #   ассоциативный массив с полями исходной записи индивидуального
          #   предпринимателя
          attr_reader :ecm_org

          # Объект доступа к данным исходной базы данных
          # @return [Cab::Tasks::Transfer::Cabinet]
          #   объект доступа к данным исходной базы данных
          attr_reader :cabinet

          # Возвращает ассоциативный массив полей импортируемой записи
          # индивидуального предпринимателя
          # @return [Hash]
          #   результирующий ассоциативный массив
          def load_entrepreneur_fields
            {}.tap do |hash|
              hash[:id]              = ecm_person_id
              hash[:commercial_name] = ecm_org[:full_name]
              hash[:ogrn]            = load_ogrn
              hash[:bank_details]    = load_bank_details
              hash[:actual_address]  = load_actual_address
              hash[:created_at]      = load_created_at
              hash[:individual_id]   = load_individual_id
            end
          end

          # Возвращает строку с датой создания записи
          # @return [String]
          #   строка с датой рождения
          def load_created_at
            ecm_org[:created_at].strftime('%FT%T')
          end

          # Формат строки ОГРН
          OGRN_FORMAT = /^[0-9]{15}$/

          # Возвращает строку с ОГРН в правильном формате или `nil`, если такую
          # строку невозможно извлечь
          # @return [String]
          #   строка с ОГРН
          # @return [NilClass]
          #   если строку с ОГРН невозможно извлечь
          def load_ogrn
            ogrn = ecm_org[:ogrnip] || ecm_person[:name]
            ogrn if OGRN_FORMAT.match?(ogrn)
          end

          # Возвращает ассоциативный массив с банковскими данными
          # индивидуального предпринимателя
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

          # Возвращает идентификатор исходной записи заявителя
          # @return [String]
          #   идентификатор исходной записи заявителя
          def ecm_person_id
            ecm_person[:id]
          end

          # Возвращает JSON-строку с фактическим адресом индивидуального
          # предпринимателя или `nil`, если фактический адрес не указан
          # @return [String]
          #   результирующая JSON-строка
          # @return [NilClass]
          #   если фактический адрес не указан
          def load_actual_address
            address = cabinet.ecm_factual_addresses[ecm_person_id]
            address && Oj.dump(address)
          end

          # Возвращает идентификатор записи физического лица, на которую
          # ссылается импортируемая запись индивидуального предпринимателя, или
          # `nil`, если идентификатор записи физического лица невозможно
          # восстановить
          # @return [String]
          #   идентификатор записи физического лица, на которую ссылается
          #   импортируемая запись индивидуального предпринимателя
          # @return [NilClass]
          #   если идентификатор записи физического лица невозможно
          #   восстановить
          def load_individual_id
            private_folder_id = ecm_person[:private_folder_id]
            ecm_person_ids =
              cabinet.ecm_private_folders[private_folder_id] || return
            ecm_person_ids.delete(ecm_person_id)
            ecm_person_ids.first
          end

          # Возвращает, отсутствует ли в базе данных запись физического лица,
          # на которую ссылается импортируемая запись индивидуального
          # предпринимателя
          # @param [Hash] fields
          #   ассоциативный массив полей импортируемой записи
          # return [Boolean]
          #   результирующее булево значение
          def absent_individual?(fields)
            Models::Individual.where(id: fields[:individual_id]).count.zero?
          end

          # Ассоциативный массив, в котором названиям полей импортируемой
          # записи индивидуального предпринимателя сопоставлены сообщения о
          # том, что эти поля не заполнены
          FIELD_MESSAGES = {
            ogrn:           'не заполнен ОГРН',
            actual_address: 'не заполнен фактический адрес'
          }.freeze

          # Сообщение о том, что запись физического лица отсутствует в базе
          # данных
          ABSENT_INDIVIDUAL_MESSAGE = 'запись о физическом лице не найдена'

          # Возвращает список с информацией о незаполненных полях
          # @param [Hash] fields
          #   ассоциативный массив полей импортируемой записи
          # @param [Array] documents
          #   список с информацией о документах
          def check_import(fields)
            [].tap do |result|
              FIELD_MESSAGES.each do |field, message|
                result << message if fields[field].nil?
              end
              result << ABSENT_INDIVIDUAL_MESSAGE if absent_individual?(fields)
            end
          end

          # Создаёт запись индивидуального предпринимателя
          # @param [Hash] fields
          #   ассоциативный массив полей импортируемой записи
          def import_entrepreneur(fields)
            model = Models::Entrepreneur
            model.unrestrict_primary_key
            model.create(fields)
            model.restrict_primary_key
          end
        end
      end
    end
  end
end
