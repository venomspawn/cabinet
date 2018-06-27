# frozen_string_literal: true

module Cab
  need 'actions/base/record_action'

  module Actions
    module Individuals
      # Класс действий обновления полей записи физического лица
      class Update < Base::RecordAction
        require_relative 'update/params_schema'

        # Обновляет поля записи физического лица
        # @return [Hash]
        #   результирующий ассоциативный массив
        def update
          record.update(individual_params)
        end

        private

        # Возвращает запись физического лица
        # @return [Cab::Models::Individual]
        #   запись физического лица
        # @raise [Sequel::NoMatchingRow]
        #   если запись физического лица не найдена
        def record
          Models::Individual.select(:id).with_pk!(id)
        end

        # Ассоциативный массив, отображающий названия ключей ассоциативного
        # массива атрибутов записи физического лица в названия ключей
        # ассоциативного массива параметров
        INDIVIDUAL_FIELDS = {
          snils:                :snils,
          inn:                  :inn,
          residence_address:    :residential_address,
          registration_address: :registration_address
        }.freeze

        # Возвращает ассоциативный массив полей записи физического лица
        # @return [Hash]
        #   результирующий ассоциативный массив
        def individual_params
          extract_params(INDIVIDUAL_FIELDS)
        end
      end
    end
  end
end
