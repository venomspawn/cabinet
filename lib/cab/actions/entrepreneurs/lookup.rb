# frozen_string_literal: true

module Cab
  need 'actions/base/action'

  module Actions
    module Entrepreneurs
      # Класс действий поиска информации об индивидуальных предпринимателях
      class Lookup < Base::Action
        require_relative 'lookup/consts'
        require_relative 'lookup/params_schema'

        include Consts

        # Возвращает ассоциативный массив с информацией об индивидуальных
        # предпринимателях
        # @return [Hash]
        #   результирующий ассоциативный массив
        def lookup
          { exact: exact, without_last_name: without_last_name, fuzzy: fuzzy }
        end

        private

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

        # Количество записей
        LIMIT = 10

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

        # Возвращает запрос Sequel на извлечение информации об индивидуальных
        # предпренимателях
        # @return [Sequel::Dataset]
        #   результирующий запрос Sequel
        def joined_dataset
          Models::Entrepreneur
            .join(:individuals, id: :individual_id)
            .naked
            .select(*FIELDS)
        end

        # Возвращает список ассоциативных массивов с информацией об
        # индивидуальных предпринимателях, найденной по точному совпадению с
        # параметрами поиска
        # @return [Array]
        #   результирующий список
        def exact
          @exact ||= joined_dataset.where(search_params).limit(LIMIT).to_a
        end

        # Возвращает пустой список, если фамилия не предоставлена в качестве
        # параметра поиска. В противном случае возвращает список ассоциативных
        # массивов с информацией об индивидуальных предпринимателях, найденной
        # по точному совпадению с параметрами поиска, кроме фамилии.
        # @return [Array]
        #   результирующий список
        def without_last_name
          return [] if last_name.blank?
          search_params_without_last_name = search_params.except(SURNAME)
          joined_dataset
            .where(search_params_without_last_name)
            .exclude(SURNAME => last_name)
            .limit(LIMIT)
            .to_a
        end

        # Возвращает запрос Sequel на извлечение записей физических лиц,
        # которые не являются индивидуальными предпринимателями
        # @return [Sequel::Dataset]
        #   результирующий запрос Sequel
        def individuals_dataset
          Models::Individual
            .naked
            .select(*INDIVIDUAL_FIELDS)
            .exclude(id: Models::Entrepreneur.select(:individual_id))
        end

        # Возвращает пустой список, если список, возвращаемый методом {exact},
        # не пуст или все параметры поиска, отвечающие имени, фамилии, отчеству
        # и месту рождения, пусты. В противном случае возвращает список
        # ассоциативных массивов с информацией об индивидуальных
        # предпринимателях и физических лицах, найденной по точному совпадению
        # даты рождения и по неточному совпадению фамилии, имени, отчества и
        # места рождения.
        # @return [Array]
        #   результирующий список
        def fuzzy
          return [] if exact.present?
          return [] if params.values_at(*FUZZY_KEYS).all?(&:blank?)
          entrepreneurs_dataset = fuzzy_dataset(joined_dataset)
          additional_dataset = fuzzy_dataset(individuals_dataset)
          entrepreneurs_dataset.to_a.concat(additional_dataset.to_a)
        end

        # Возвращает запрос Sequel на извлечение записей индивидуальных
        # предпринимателей или физических лиц по неточному совпадению (см.
        # {fuzzy})
        # @param [Sequel::Dataset] dataset
        #   исходный запрос Sequel на извлечение записей индивидуальных
        #   предпринимателей или физических лиц
        # @return [Sequel::Dataset]
        #   результирующий запрос Sequel
        def fuzzy_dataset(dataset)
          condition = { BIRTHDAY => birth_date }
          dataset = dataset.where(condition) if birth_date.present?
          fuzzy_percents_dataset(dataset)
            .order_by(total_distance.asc)
            .limit(LIMIT)
        end

        # Возвращает запрос Sequel, полученный из предоставленного добавлением
        # условий на похожесть значений полей и значений параметров
        # @param [Sequel::Dataset] dataset
        #   запрос Sequel
        # @return [Sequel::Dataset]
        #   результирующий запрос Sequel
        def fuzzy_percents_dataset(dataset)
          FUZZY_KEYS.inject(dataset) do |memo, key|
            value = params[key]
            next memo if value.blank?
            condition = percent_expression(SEARCH_KEYS[key], value)
            memo.where(condition)
          end
        end

        # Возвращает выражение Sequel для проверки, что похожесть значения поля
        # и предоставленного значения выше порога
        # @param [Sequel::SQL::QualifiedIdentifier] field
        #   название поля
        # @param [#to_s] value
        #   значение
        # @return [Sequel::SQL::Expression]
        #   результирующее выражение Sequel
        def percent_expression(field, value)
          "\"#{field.table}\".\"#{field.column}\" % '#{value}'".lit
        end

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
        # @param [Sequel::SQL::QualifiedIdentifier] field
        #   название поля
        # @param [#to_s] value
        #   строка
        # @param [#to_s] weight
        #   вес
        # @return [Sequel::SQL::Expression]
        #   результирующее выражение Sequel
        def similarity_distance(field, value, weight)
          "(\"#{field.table}\".\"#{field.column}\" <-> '#{value}') * #{weight}"
            .lit
        end
      end
    end
  end
end
