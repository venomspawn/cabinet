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

        # Возвращает значение параметра `last_name`
        # @return [Object]
        #   значение параметра `last_name`
        def last_name
          params[:last_name]
        end

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

        # Максимальное количество возвращаемых записей
        LIMIT = 10

        # Запрос Sequel на извлечение записей физических лиц
        INDIVIDUALS_DATASET =
          Models::Individual.naked.select(*FIELDS).limit(LIMIT)

        # Возвращает список ассоциативных массивов с информацией о физических
        # лицах, найденной по точному совпадению с параметрами поиска
        # @return [Array]
        #   результирующий список
        def exact
          @exact ||= INDIVIDUALS_DATASET.where(search_params).to_a
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
          INDIVIDUALS_DATASET
            .where(search_params_without_last_name)
            .exclude(surname: last_name)
            .to_a
        end

        # Возвращает пустой список, если метод {exact} возвращает непустой
        # список или непустые параметры нечёткого поиска отсуствуют, в
        # противном случае возвращает список ассоциативных массивов с
        # информацией о физических лицах, найденной по точному совпадению даты
        # рождения и по неточному совпадению фамилии, имени, отчества и места
        # рождения
        # @return [Array]
        #   результирующий список
        def fuzzy
          return [] unless exact.empty?
          engine = Cab::Lookup::Fuzzy.new(params)
          engine.empty_params? ? [] : engine.dataset(INDIVIDUALS_DATASET).to_a
        end
      end
    end
  end
end
