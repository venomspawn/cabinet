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
    # @!attribute director
    #   Имя руководителя
    #   @return [String]
    #     имя руководителя
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
    class Organization < Sequel::Model
    end
  end
end
