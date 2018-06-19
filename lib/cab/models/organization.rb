# frozen_string_literal: true

module Cab
  module Models
    # Модель записи организации
    # @!attribute id
    #   Идентификатор
    #   @return [String]
    #     идентификатор
    # @!attribute full_name
    #   Полное наименование
    #   @return [String]
    #     полное наименование
    # @!attribute short_name
    #   Сокращённое наименование
    #   @return [NilClass, String]
    #     сокращённое наименование
    # @!attribute chief_name
    #   Имя руководителя
    #   @return [String]
    #     имя руководителя
    # @!attribute chief_surname
    #   Фамилия руководителя
    #   @return [String]
    #     фамилия руководителя
    # @!attribute chief_middle_name
    #   Отчество руководителя
    #   @return [NilClass, String]
    #     отчество руководителя
    # @!attribute registration_date
    #   Дата регистрации
    #   @return [Date]
    #     дата регистрации
    # @!attribute inn
    #   ИНН
    #   @return [String]
    #     ИНН
    # @!attribute kpp
    #   КПП
    #   @return [String]
    #     КПП
    # @!attribute ogrn
    #   ОГРН
    #   @return [String]
    #     ОГРН
    # @!attribute legal_address
    #   Юридический адрес
    #   @return [Object]
    #     юридический адрес
    # @!attribute actual_address
    #   Фактический адрес
    #   @return [Object]
    #     фактический адрес
    # @!attribute bank_details
    #   Банковские реквизиты
    #   @return [Object]
    #     банковские реквизиты
    # @!attribute created_at
    #   Дата и время создания
    #   @return [Time]
    #     дата и время создания
    class Organization < Sequel::Model
    end
  end
end
