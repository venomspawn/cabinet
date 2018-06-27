# frozen_string_literal: true

module Cab
  need 'actions/base/record_action'

  module Actions
    module Organizations
      # Класс действий обновления полей записей юридических лиц
      class Update < Base::RecordAction
        require_relative 'update/params_schema'

        # Обновляет поля записи юридического лица
        # @raise [Sequel::NoMatchingRow]
        #   если запись юридического лица не найдена
        def update
          record.update(organization_params)
        end

        private

        # Возвращает запись юридического лица
        # @return [Cab::Models::Organization]
        #   запись юридического лица
        # @raise [Sequel::NoMatchingRow]
        #   если запись юридического лица не найдена
        def record
          Models::Organization.select(:id).with_pk!(id)
        end

        # Ассоциативный массив, отображающий названия ключей ассоциативного
        # массива атрибутов записи юридического лица в названия ключей
        # ассоциативного массива параметров
        ORGANIZATION_FIELDS = {
          full_name:         :full_name,
          short_name:        :sokr_name,
          chief_name:        :chief_name,
          chief_surname:     :chief_surname,
          chief_middle_name: :chief_middle_name,
          registration_date: :registration_date,
          inn:               :inn,
          kpp:               :kpp,
          ogrn:              :ogrn,
          legal_address:     :legal_address,
          actual_address:    :actual_address,
          bank_details:      :bank_details
        }.freeze

        # Возвращает ассоциативный массив полей записи юридического лица
        # @return [Hash]
        #   результирующий ассоциативный массив
        def organization_params
          extract_params(ORGANIZATION_FIELDS)
        end
      end
    end
  end
end
