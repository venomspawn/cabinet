# frozen_string_literal: true

module Cab
  module Models
    # Модель записи связи между записями организаций и их представителей
    # @!attribute created_at
    #   Дата и время создания
    #   @return [Time]
    #     дата и время создания
    # @!attribute spokesman_id
    #   Идентификатор записи представителя
    #   @return [String]
    #     идентификатор записи представителя
    # @!attribute organization_id
    #   Идентификатор записи организации
    #   @return [String]
    #     идентификатор записи организации
    # @!attribute vicarious_authority_id
    #   Идентификатор записи документа, подтверждающего полномочия
    #   представителя
    #   @return [String]
    #     идентификатор записи документа, подтверждающего полномочия
    #     представителя
    class OrganizationSpokesman < Sequel::Model
    end
  end
end
