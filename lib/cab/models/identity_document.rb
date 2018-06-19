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
    # @!attribute created_at
    #   Дата и время создания
    #   @return [Time]
    #     дата и время создания
    # @!attribute individual_id
    #   Идентификатор записи физического лица
    #   @return [String]
    #     идентификатор записи физического лица
    class IdentityDocument < Sequel::Model
      # Типы документов
      TYPES = %i[
        foreign_citizen_passport
        residence
        temporary_residence
        refugee_certificate
        certificate_of_temporary_asylum_rf
        passport_rf
        international_passport
        seaman_passport
        officer_identity_document
        soldier_identity_document
        temporary_identity_card
        birth_certificate
      ].freeze
    end
  end
end
