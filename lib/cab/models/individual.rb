# frozen_string_literal: true

module Cab
  # Пространство имён моделей
  module Models
    # Модель записи физического лица
    # @!attribute id
    #   Идентификатор
    #   @return [String]
    #     идентификатор
    # @!attribute name
    #   Имя
    #   @return [String]
    #     имя
    # @!attribute surname
    #   Фамилия
    #   @return [String]
    #     фамилия
    # @!attribute middle_name
    #   Отчество
    #   @return [NilClass, String]
    #     отчество
    # @!attribute birth_place
    #   Место рождения
    #   @return [String]
    #     место рождения
    # @!attribute birthday
    #   Дата рождения
    #   @return [Date]
    #     дата рождения
    # @!attribute sex
    #   Пол
    #   @return [String]
    #     пол
    # @!attribute citizenship
    #   Гражданство
    #   @return [String]
    #     гражданство
    # @!attribute snils
    #   СНИЛС
    #   @return [NilClass, String]
    #     СНИЛС
    # @!attribute inn
    #   ИНН
    #   @return [NilClass, String]
    #     ИНН
    # @!attribute registration_address
    #   Адрес регистрации
    #   @return [Object]
    #     адрес регистрации
    # @!attribute residence_address
    #   Адрес проживания
    #   @return [Object]
    #     адрес проживания
    # @!attribute temp_residence_address
    #   Адрес временного проживания
    #   @return [Object]
    #     адрес временного проживания
    # @!attribute created_at
    #   Дата и время создания
    #   @return [Time]
    #     дата и время создания
    # @!attribute agreement_id
    #   Идентификатор записи файла с соглашением на обработку персональных
    #   данных
    #   @return [String]
    #     идентификатор записи файла с соглашением на обработку персональных
    #     данных
    class Individual < Sequel::Model
    end
  end
end
