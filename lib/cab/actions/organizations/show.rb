# frozen_string_literal: true

module Cab
  need 'actions/base/action'

  module Actions
    module Organizations
      class Show < Base::Action
        require_relative 'show/params_schema'

        # Возвращает ассоциативный массив с информацией о физическом лице
        # @return [Hash]
        #   результирующий ассоциативный массив
        def show
          values.tap do |result|
            result[:client_type] = :organization
            form_director(result)
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
          .sql_function(:registration_date, 'YYYY-MM-DD')
          .as(:registration_date)

        # Названия полей записи физического лица, извлекаемых из базы данных
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

        # Возвращает ассоциативный массив полей записи физического лица
        # @return [Hash]
        #   результирующий ассоциативный массив
        # @raise [Sequel::NoMatchingRow]
        #   если запись физического лица не найдена
        def values
          Models::Organization.naked.select(*FIELDS).where(id: id).first!
        end

        # Названия ключей ассоциативного массива с информацией о юридическом
        # лице, из значений которых формируется значение поля с полным именем
        # руководителя юридического лица
        DIRECTOR_PARTS = %i[chief_surname chief_name chief_middle_name]

        # Удаляет из ассоциативного массива с информацией о юридическом лице ш
        # ключи частями полного имени руководителя юридического лица и
        # добавляет в него новое поле с полным именем руководителя юридического
        # лица
        # @param [Hash] result
        #   ассоциативный массив с информацией о юридическом лице
        def form_director(result)
          parts =
            DIRECTOR_PARTS.map(&result.method(:delete)).find_all(&:present?)
          result[:director] = parts.join(' ')
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
