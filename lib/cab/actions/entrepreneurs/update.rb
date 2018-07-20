# frozen_string_literal: true

module Cab
  need 'actions/base/action'

  module Actions
    module Entrepreneurs
      # Класс действий обновления полей записей индивидуальных предпринимателей
      class Update < Base::Action
        require_relative 'update/params_schema'

        # Обновляет поля записи индивидуального предпринимателя
        def update
          Sequel::Model.db.transaction(savepoint: true) do
            record.update(entrepreneur_params)
            individual.update(individual_params)
          end
        end

        private

        # Возвращает значение параметра `id`
        # @return [String]
        #   значение параметра `id`
        def id
          params[:id]
        end

        # Возвращает запись индивидуального предпринимателя
        # @return [Cab::Models::Entrepreneur]
        #   запись индивидуального предпринимателя
        # @raise [Sequel::NoMatchingRow]
        #   если запись индвидуального предпринимателя не найдена
        def record
          @record ||=
            Models::Entrepreneur.select(:id, :individual_id).with_pk!(id)
        end

        # Возвращает запись физического лица
        # @return [Cab::Models::Individual]
        #   запись физического лица
        # @raise [Sequel::NoMatchingRow]
        #   если запись физического лица не найдена
        def individual
          Models::Individual.select(:id).with_pk!(record.individual_id)
        end

        # Ассоциативный массив, отображающий названия ключей ассоциативного
        # массива атрибутов записи физического лица в названия ключей
        # ассоциативного массива параметров
        INDIVIDUAL_FIELDS = {
          snils:                :snils,
          inn:                  :inn,
          registration_address: :registration_address
        }.freeze

        # Возвращает ассоциативный массив параметров обновления записи
        # физического лица
        # @return [Hash]
        #   результирующий ассоциативный массив
        def individual_params
          extract_params(INDIVIDUAL_FIELDS)
        end

        # Ассоциативный массив, отображающий названия ключей ассоциативного
        # массива атрибутов записи индивидуального предпринимателя в названия
        # ключей ассоциативного массива параметров
        ENTREPRENEUR_FIELDS = {
          actual_address:  :actual_address,
          bank_details:    :bank_details,
          commercial_name: :commercial_name,
          ogrn:            :ogrn
        }.freeze

        # Возвращает ассоциативный массив параметров обновления записи
        # индивидуального предпринимателя
        # @return [Hash]
        #   результирующий ассоциативный массив
        def entrepreneur_params
          extract_params(ENTREPRENEUR_FIELDS)
        end
      end
    end
  end
end
