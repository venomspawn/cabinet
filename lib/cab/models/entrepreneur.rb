# frozen_string_literal: true

module Cab
  module Models
    # Модель записи индивидуального предпринимателя
    # @!attribute id
    #   Идентификатор
    #   @return [String]
    #     идентификатор
    # @!attribute commerical_name
    #   Коммерческое наименование
    #   @return [String]
    #     коммерческое наименование
    # @!attribute ogrn
    #   ОГРН
    #   @return [String]
    #     ОГРН
    # @!attribute bank_details
    #   Банковские реквизиты
    #   @return [Object]
    #     банковские реквизиты
    # @!attribute actual_address
    #   Фактический адрес
    #   @return [Object]
    #     фактический адрес
    # @!attribute created_at
    #   Дата и время создания
    #   @return [Time]
    #     дата и время создания
    # @!attribute individual_id
    #   Идентификатор записи физического лица
    #   @return [String]
    #     идентификатор записи физического лица
    class Entrepreneur < Sequel::Model
    end
  end
end
