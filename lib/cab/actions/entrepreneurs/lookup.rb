# frozen_string_literal: true

module Cab
  need 'actions/base/action'

  module Actions
    module Entrepreneurs
      # Класс действий поиска информации об индивидуальных предпринимателях
      class Lookup < Base::Action
        require_relative 'lookup/params_schema'

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

        # Выражение для извлечения имени индивидуального предпринимателя
        NAME = :name.qualify(:individuals)

        # Выражение для извлечения фамилии индивидуального предпринимателя
        SURNAME = :surname.qualify(:individuals)

        # Выражение для извлечения отчества индивидуального предпринимателя
        MIDDLE_NAME = :middle_name.qualify(:individuals)

        # Выражение для извлечения даты рождения индивидуального
        # предпринимателя
        BIRTHDAY = :birthday.qualify(:individuals)

        # Выражение для извлечения места рождения индивидуального
        # предпринимателя
        BIRTH_PLACE = :birth_place.qualify(:individuals)

        # Выражение для извлечения ИНН индивидуального предпринимателя
        INN = :inn.qualify(:individuals)

        # Выражение для извлечения СНИЛС индивидуального предпринимателя
        SNILS = :inn.qualify(:individuals)

        # Ассоциативный массив, преобразующий названия параметров поиска в
        # названия полей записей физических лиц
        SEARCH_KEYS = {
          first_name:  NAME,
          middle_name: MIDDLE_NAME,
          last_name:   SURNAME,
          birth_date:  BIRTHDAY,
          birth_place: BIRTH_PLACE,
          inn:         INN,
          snils:       SNILS
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

        # Выражение для извлечения имени индивидуального предпринимателя в
        # качестве поля результирующего ассоциативного массива
        FIRST_NAME = NAME.as(:first_name)

        # Выражение для извлечения фамилии индивидуального предпринимателя в
        # качестве поля результирующего ассоциативного массива
        LAST_NAME = SURNAME.as(:last_name)

        # Выражение для извлечения даты рождения индивидуального
        # предпринимателя в правильном формате в качестве поля
        # результирующего ассоциативного массива
        BIRTH_DATE =
          :to_char.sql_function(BIRTHDAY, 'DD.MM.YYYY').as(:birth_date)

        # Поля записей индивидуальных предпринимателей, извлекаемые из базы
        # данных
        FIELDS = [
          'entrepreneur'.as(:client_type),
          :id.qualify(:entrepreneurs),
          FIRST_NAME,
          LAST_NAME,
          MIDDLE_NAME,
          BIRTH_DATE,
          BIRTH_PLACE,
          INN
        ].freeze

        # Количество записей
        LIMIT = 10

        # Запрос Sequel на извлечение информации об индивидуальных
        # предпринимателях
        JOINED_DATASET =
          Models::Entrepreneur
          .join(:individuals, id: :individual_id)
          .naked
          .select(*FIELDS)
          .limit(LIMIT)

        # Возвращает список ассоциативных массивов с информацией об
        # индивидуальных предпринимателях, найденной по точному совпадению с
        # параметрами поиска
        # @return [Array]
        #   результирующий список
        def exact
          @exact ||= JOINED_DATASET.where(search_params).to_a
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
          JOINED_DATASET
            .where(search_params_without_last_name)
            .exclude(SURNAME => last_name)
            .to_a
        end

        # Поля записей физических лиц, извлекаемые из базы данных
        INDIVIDUAL_FIELDS = [
          'individual'.as(:client_type),
          :id,
          NAME,
          LAST_NAME,
          MIDDLE_NAME,
          BIRTH_DATE,
          BIRTH_PLACE,
          INN
        ].freeze

        # Запрос Sequel на извлечение записей физических лиц, которые не
        # являются индивидуальными предпринимателями
        INDIVIDUALS_DATASET =
          Models::Individual
          .naked
          .select(*INDIVIDUAL_FIELDS)
          .exclude(id: Models::Entrepreneur.select(:individual_id))
          .limit(LIMIT)

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
          engine = Cab::Lookup::Fuzzy.new(params)
          return [] if engine.empty_params?
          engine
            .dataset(JOINED_DATASET)
            .to_a
            .concat(engine.dataset(INDIVIDUALS_DATASET).to_a)
        end
      end
    end
  end
end
