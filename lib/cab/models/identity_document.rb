# frozen_string_literal: true

module Cab
  module Models
    # Модель записи документа, удостоверяющего личность
    # @!attribute id
    #   Идентификатор
    #   @return [String]
    #     идентификатор
    # @!attribute type
    #   Тип
    #   @return [String]
    #     тип
    # @!attribute number
    #   Номер
    #   @return [NilClass, String]
    #     номер
    # @!attribute series
    #   Серия
    #   @return [String]
    #     серия
    # @!attribute issued_by
    #   Кем выдан
    #   @return [String]
    #     кем выдан
    # @!attribute issue_date
    #   Дата выдачи
    #   @return [Date]
    #     дата выдачи
    # @!attribute expiration_end
    #   Дата окончания действия
    #   @return [Date]
    #     дата окончания действия
    # @!attribute division_code
    #   Код выдавшего подразделения
    #   @return [String]
    #     код выдавшего подразделения
    # @!attribute content
    #   Содержимое файла
    #   @return [String]
    #     содержимое файла
    # @!attribute individual_id
    #   Идентификатор записи физического лица
    #   @return [String]
    #     идентификатор записи физического лица
    class IdentityDocument < Sequel::Model
    end
  end
end
