# frozen_string_literal: true

module Cab
  module Models
    # Модель записи документа, подтверждающей полномочия представителя
    # @!attribute id
    #   Идентификатор
    #   @return [String]
    #     идентификатор
    # @!attribute name
    #   Наименование
    #   @return [String]
    #     наименования
    # @!attribute number
    #   Номер
    #   @return [NilClass, String]
    #     номер
    # @!attribute series
    #   Серия
    #   @return [NilClass, String]
    #     серия
    # @!attribute registry_number
    #   Реестровый номер
    #   @return [String]
    #     реестровый номер
    # @!attribute issued_by
    #   Кем выдан
    #   @return [String]
    #     кем выдан
    # @!attribute issue_date
    #   Дата выдачи
    #   @return [Date]
    #     дата выдачи
    # @!attribute expiration_date
    #   Дата окончания действия
    #   @return [Date]
    #     дата окончания действия
    # @!attribute created_at
    #   Дата и время создания
    #   @return [Time]
    #     дата и время создания
    # @!attribute file_id
    #   Идентификатор записи файла
    #   @return [String]
    #     идентификатор записи файла
    class VicariousAuthority < Sequel::Model
    end
  end
end
