# frozen_string_literal: true

module Cab
  need 'actions/base/action'

  module Actions
    module Organizations
      # Класс действий поиска информации о юридических лицах
      class Lookup < Base::Action
        require_relative 'lookup/params_schema'

        # Возвращает ассоциативный массив с информацией о юридических лицах
        # @return [Hash]
        #   результирующий ассоциативный массив
        def lookup
          { exact: exact, without_inn: without_inn, fuzzy: fuzzy }
        end

        private

        # Количество записей
        LIMIT = 10

        # Возвращает значение параметра `full_name`
        # @return [Object]
        #   значение параметра `full_name`
        def full_name
          params[:full_name]
        end

        # Возвращает значение параметра `inn`
        # @return [Object]
        #   значение параметра `inn`
        def inn
          params[:inn]
        end

        # Возвращает выражение Sequel для фильтрации записей юридических лиц по
        # параметрам поиска с непустыми значениями
        # @param [Array] search_keys
        #   список названий параметров
        # @return [Sequel::SQL::Expression]
        #   результирующее выражение
        def search_params(*search_keys)
          search_keys.each_with_object([]) do |key, memo|
            value = params[key]
            next if value.blank?
            memo << if key == :legal_address
                      value = Oj.dump(value)
                      :legal_address.pg_jsonb.contains(value)
                    else
                      Sequel::SQL::BooleanExpression.new(:'=', key, value)
                    end
          end
        end

        # Поля записей юридических лиц, извлекаемые из базы данных
        FIELDS =
          ['organization'.as(:client_type), :id, :full_name, :inn].freeze

        # Возвращает запрос Sequel на извлечение записей организаций
        # @return [Sequel::Dataset]
        #   результирующий запрос Sequel
        def dataset
          Models::Organization.naked.select(*FIELDS)
        end

        # Возвращает список ассоциативных массивов с информацией о юридических
        # лицах, найденной по точному совпадению с параметрами поиска
        # @return [Array]
        #   результирующий список
        def exact
          @exact ||=
            search_params(:full_name, :inn, :legal_address)
            .inject(dataset) { |memo, param| memo.where(param) }
            .limit(LIMIT)
            .to_a
        end

        # Возвращает пустой список, если ИНН не предоставлена в качестве
        # параметра поиска. В противном случае возвращает список ассоциативных
        # массивов с информацией о юридических лицах, найденной по точному
        # совпадению с параметрами поиска, кроме ИНН.
        # @return [Array]
        #   результирующий список
        def without_inn
          return [] if inn.blank?
          search_params(:full_name, :legal_address)
            .inject(dataset) { |memo, param| memo.where(param) }
            .exclude(inn: inn)
            .limit(LIMIT)
            .to_a
        end

        # Названия параметров поиска, по которым производится нечёткий поиск
        FUZZY_KEYS = %i[first_name middle_name full_name birth_place].freeze

        # Возвращает пустой список, если список, возвращаемый методом {exact},
        # не пуст или полное название юридического лица отсутствует в
        # параметрах поиска. В противном случае возвращает список ассоциативных
        # массивов с информацией о юридических лицах, найденной по неточному
        # совпадению полного названия юридического лица.
        # @return [Array]
        #   результирующий список
        def fuzzy
          return [] if exact.present? || full_name.blank?
          dataset
            .where("\"full_name\" % '#{full_name}'".lit)
            .order_by("\"full_name\" <-> '#{full_name}'".lit.asc)
            .limit(LIMIT)
            .to_a
        end
      end
    end
  end
end
