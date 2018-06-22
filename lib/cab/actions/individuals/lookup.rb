# frozen_string_literal: true

module Cab
  need 'actions/base/action'

  module Actions
    module Individuals
      # Класс действий поиска информации о физических лицах
      class Lookup < Base::Action
        require_relative 'lookup/params_schema'

        # Возвращает ассоциативный массив с информацией о физических лицах
        # @return [Hash]
        #   результирующий ассоциативный массив
        def lookup
          { exact: exact, without_last_name: without_last_name, fuzzy: fuzzy }
        end

        private

        # Поля записей физических лиц, извлекаемые из базы данных
        FIELDS = [
          'individual'.as(:client_type),
          :id,
          :name.as(:first_name),
          :surname.as(:last_name),
          :middle_name,
          :birth_place,
          :to_char.sql_function(:birthday, 'DD.MM.YYYY').as(:birth_date)
        ].freeze

        # Количество записей
        LIMIT = 10

        # Ассоциативный массив, преобразующий названия параметров поиска в
        # названия полей записей физических лиц
        SEARCH_KEYS = {
          first_name:  :name,
          middle_name: :middle_name,
          last_name:   :surname,
          birth_date:  :birthday,
          birth_place: :birth_place,
          inn:         :inn,
          snils:       :snils
        }.freeze

        # Возвращает значение параметра `last_name`
        # @return [Object]
        #   значение параметра `last_name`
        def last_name
          params[:last_name]
        end

        # Возвращает значение параметра `birth_date`
        # @return [Object]
        #   значение параметра `birth_date`
        def birth_date
          params[:birth_date]
        end

        # Возвращает ассоциативный массив, полученный из параметров поиска, из
        # которого исключены все пустые значения
        # @return [Hash]
        #   результирующий ассоциативный массив
        def search_params
          @search_params ||=
            SEARCH_KEYS.each_with_object({}) do |(key, field), memo|
              value = params[key]
              memo[field] = value unless value.blank?
            end
        end

        # Возвращает список ассоциативных массивов с информацией о физических
        # лицах, найденной по точному совпадению с параметрами поиска
        # @return [Array]
        #   результирующий список
        def exact
          @exact ||=
            Models::Individual
            .naked
            .select(*FIELDS)
            .where(search_params)
            .limit(LIMIT)
            .to_a
        end

        # Возвращает пустой список, если фамилия не предоставлена в качестве
        # параметра поиска. В противном случае возвращает список ассоциативных
        # массивов с информацией о физических лицах, найденной по точному
        # совпадению с параметрами поиска, кроме фамилии.
        # @return [Array]
        #   результирующий список
        def without_last_name
          return [] if last_name.blank?
          search_params_without_last_name = search_params.except(:surname)
          Models::Individual
            .naked
            .select(*FIELDS)
            .where(search_params_without_last_name)
            .exclude(surname: last_name)
            .limit(LIMIT)
            .to_a
        end

        # Названия параметров поиска, по которым производится нечёткий поиск
        FUZZY_KEYS = %i[first_name middle_name last_name birth_place].freeze

        # Возвращает пустой список, если список, возвращаемый методом {exact},
        # не пуст или все параметры поиска, отвечающие имени, фамилии, отчеству
        # и месту рождения, пусты. В противном случае возвращает список
        # ассоциативных массивов с информацией о физических лицах, найденной по
        # точному совпадению даты рождения и по неточному совпадению фамилии,
        # имени, отчества и места рождения.
        # @return [Array]
        #   результирующий список
        def fuzzy
          return [] if exact.present?
          return [] if params.values_at(*FUZZY_KEYS).all?(&:blank?)
          fuzzy_dataset.to_a
        end

        # Возвращает запрос Sequel на извлечение записей физических лиц по
        # неточному совпадению (см. {fuzzy})
        # @return [Sequel::Dataset]
        #   результирующий запрос Sequel
        def fuzzy_dataset
          dataset = Models::Individual.naked.select(*FIELDS)
          dataset = dataset.where(birthday: birth_date) if birth_date.present?
          FUZZY_KEYS.each do |key|
            value = params[key]
            next if value.blank?
            condition = percent_expression(SEARCH_KEYS[key], value)
            dataset = dataset.where(condition)
          end
          dataset.order_by(total_distance.asc).limit(LIMIT)
        end

        # Возвращает выражение Sequel для проверки, что похожесть значения поля
        # и предоставленного значения выше порога
        # @param [#to_s] field
        #   название поля
        # @param [#to_s] value
        #   значение
        # @return [Sequel::SQL::Expression]
        #   результирующее выражение Sequel
        def percent_expression(field, value)
          Sequel.lit("\"#{field}\" % '#{value}'")
        end

        # Ассоциативный массив, в котором названия параметров поиска
        # сопоставляются их веса в вычислении общей похожести
        WEIGHTS = {
          last_name:   1.0,
          first_name:  1.5,
          middle_name: 2.0,
          birth_place: 1.8
        }.freeze

        # Возвращает выражение Sequel для вычисления общей похожести
        # @return [Sequel::SQL::Expression]
        #   результирующие выражение Sequel
        def total_distance
          expressions = FUZZY_KEYS.each_with_object([]) do |key, memo|
            value = params[key]
            next if value.blank?
            memo << similarity_distance(SEARCH_KEYS[key], value, WEIGHTS[key])
          end
          expressions.inject(:+)
        end

        # Возвращает выражение Sequel для вычисления похожести значения поля и
        # предоставленной строки, умноженного на вес
        # @param [#to_s] field
        #   название поля
        # @param [#to_s] value
        #   строка
        # @param [#to_s] weight
        #   вес
        # @return [Sequel::SQL::Expression]
        #   результирующее выражение Sequel
        def similarity_distance(field, value, weight)
          Sequel.lit("(\"#{field}\" <-> '#{value}') * #{weight}")
        end
      end
    end
  end
end
