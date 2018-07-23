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
            update_entrepreneur
            update_individual
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

        # Обновляет поля записи индивидуального предпринимателя
        def update_entrepreneur
          record.update(entrepreneur_params)
        end

        # Обновляет поля записи физического лица, к которой прикреплена запись
        # индивидуального предпринимателя
        def update_individual
          Models::Individual
            .where(id: record.individual_id)
            .update(individual_params)
        end

        # Ассоциативный массив, отображающий названия ключей ассоциативного
        # массива атрибутов записи физического лица в названия ключей
        # ассоциативного массива параметров
        INDIVIDUAL_FIELDS = { snils: :snils, inn: :inn, }.freeze

        # Возвращает ассоциативный массив параметров обновления записи
        # физического лица
        # @return [Hash]
        #   результирующий ассоциативный массив
        def individual_params
          extract_params(INDIVIDUAL_FIELDS).tap do |hash|
            hash[:registration_address] =
              Oj.dump(params[:registration_address])
          end
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
