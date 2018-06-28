# frozen_string_literal: true

module Cab
  need 'actions/base/action'

  module Actions
    module Organizations
      # Класс действий извлечения информации о юридических лицах
      class Show < Base::Action
        require_relative 'show/params_schema'

        # Возвращает ассоциативный массив с информацией о юридическом лице
        # @return [Hash]
        #   результирующий ассоциативный массив
        def show
          values.tap do |result|
            result[:client_type] = :organization
            expand_json(result, :legal_address)
            expand_json(result, :actual_address)
            expand_json(result, :bank_details)
          end
        end

        private

        # Возвращает значение параметра `id`
        # @return [String]
        #   значение параметра `id`
        def id
          params[:id]
        end

        # Определение функции извлечения информации о дате регистрации
        # юридического лица
        REGISTRATION_DATE =
          :to_char
          .sql_function(:registration_date, 'DD.MM.YYYY')
          .as(:registration_date)

        # Названия полей записи юридического лица, извлекаемых из базы данных
        FIELDS = [
          :id,
          :full_name,
          :short_name.as(:sokr_name),
          :chief_name,
          :chief_surname,
          :chief_middle_name,
          REGISTRATION_DATE,
          :inn,
          :kpp,
          :ogrn,
          :legal_address.cast(:text),
          :actual_address.cast(:text),
          :bank_details.cast(:text)
        ].freeze

        # Возвращает ассоциативный массив полей записи юридического лица
        # @return [Hash]
        #   результирующий ассоциативный массив
        # @raise [Sequel::NoMatchingRow]
        #   если запись юридического лица не найдена
        def values
          Models::Organization.naked.select(*FIELDS).where(id: id).first!
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
      end
    end
  end
end
