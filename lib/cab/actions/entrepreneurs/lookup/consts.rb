# frozen_string_literal: true

module Cab
  module Actions
    module Entrepreneurs
      class Lookup
        # Модуль констант, используемых в содержащем классе
        module Consts
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

          # Выражение для типа записи индивидуального предпринимателя
          CLIENT_TYPE = 'entrepreneur'.as(:client_type)

          # Выражение для извлечения идентификатора записи индивидуального
          # предпринимателя
          ID = :id.qualify(:entrepreneurs)

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

          # Поля записей индивидуальных предпринимателей, извлекаемые из базы
          # данных
          FIELDS = [
            CLIENT_TYPE,
            ID,
            FIRST_NAME,
            LAST_NAME,
            MIDDLE_NAME,
            BIRTH_DATE,
            BIRTH_PLACE,
            INN
          ].freeze

          # Названия параметров поиска, по которым производится нечёткий поиск
          FUZZY_KEYS = %i[first_name middle_name last_name birth_place].freeze

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

          # Ассоциативный массив, в котором названия параметров поиска
          # сопоставляются их веса в вычислении общей похожести
          WEIGHTS = {
            last_name:   1.0,
            first_name:  1.5,
            middle_name: 2.0,
            birth_place: 1.8
          }.freeze
        end
      end
    end
  end
end
