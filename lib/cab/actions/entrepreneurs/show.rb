# frozen_string_literal: true

module Cab
  need 'actions/base/action'

  module Actions
    module Entrepreneurs
      # Класс действий извлечения информации об индивидуальных предпринимателях
      class Show < Base::Action
        require_relative 'show/params_schema'

        # Возвращает ассоциативный массив с информацией об индивидуальном
        # предпринимателе
        # @return [Hash]
        #   результирующий ассоциативный массив
        def show
          values.tap do |result|
            result[:client_type] = :entrepreneur
            expand_json(result, :actual_address)
            expand_json(result, :bank_details)
            inject_individual_info(result)
          end
        end

        private

        # Возвращает значение параметра `id`
        # @return [String]
        #   значение параметра `id`
        def id
          params[:id]
        end

        # Возвращает значение параметра `extended`
        # @return [String]
        #   значение параметра `id`
        def extended
          params[:extended]
        end

        # Названия полей записи индивидуального предпринимателя, извлекаемых их
        # базы данных
        FIELDS = [
          :id,
          :commercial_name,
          :ogrn,
          :actual_address.cast(:text),
          :bank_details.cast(:text),
          :individual_id
        ].freeze

        # Возвращает ассоциативный массив полей записи индивидуального
        # предпринимателя
        # @return [Hash]
        #   результирующий ассоциативный массив
        # @raise [Sequel::NoMatchingRow]
        #   если запись индивидуального предпринимателя не найдена
        def values
          Models::Entrepreneur.naked.select(*FIELDS).where(id: id).first!
        end

        # Заменяет значение по данному ключу ассоциативного массива структурой,
        # восстановленной из JSON-строки, которая была исходным значением
        # @param [Hash] hash
        #   ассоциативный массив
        # @param [Object] key
        #   ключ
        def expand_json(hash, key)
          hash[key] &&= Oj.load(hash[key])
        end

        # Ключи, значения которых должны быть скопированы из ассоциативного
        # массива с информацией о физическом лице в ассоциативный массив с
        # информацией об индивидуальном предпринимателе
        INDIVIDUAL_INFO_KEYS = %i[
          first_name
          last_name
          middle_name
          birth_place
          birth_date
          sex
          citizenship
          inn
          snils
          registration_address
          agreement_id
          identity_documents
        ].freeze

        # Добавляет в ассоциативный массив с информацией об индивидуальном
        # предпринимателе информацию о физическом лице
        # @param [Hash] result
        #   ассоциативный массив с информацией об индивидуальном
        #   предпринимателе
        def inject_individual_info(result)
          individual_id = result.delete(:individual_id)
          individual_info =
            Individuals.show(id: individual_id, extended: extended)
          INDIVIDUAL_INFO_KEYS.each do |key|
            result[key] = individual_info[key] if individual_info.key?(key)
          end
        end
      end
    end
  end
end
