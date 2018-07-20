# frozen_string_literal: true

module Cab
  need 'actions/base/action'

  module Actions
    module Individuals
      # Класс действий обновления полей записи физического лица
      class Update < Base::Action
        require_relative 'update/params_schema'

        # Обновляет поля записи физического лица
        def update
          record.update(individual_params)
        end

        private

        # Возвращает значение параметра `id`
        # @return [String]
        #   значение параметра `id`
        def id
          params[:id]
        end

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
