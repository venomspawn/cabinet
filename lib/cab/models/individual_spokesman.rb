# frozen_string_literal: true

module Cab
  module Models
    # Модель записи связи между записями физических лиц и их представителей
    # @!attribute created_at
    #   Дата и время создания
    #   @return [Time]
    #     дата и время создания
    # @!attribute spokesman_id
    #   Идентификатор записи представителя
    #   @return [String]
    #     идентификатор записи представителя
    # @!attribute individual_id
    #   Идентификатор записи физического лица
    #   @return [String]
    #     идентификатор записи физического лица
    # @!attribute vicarious_authority_id
    #   Идентификатор записи документа, подтверждающего полномочия
    #   представителя
    #   @return [String]
    #     идентификатор записи документа, подтверждающего полномочия
    #     представителя
    class IndividualSpokesman < Sequel::Model
    end
  end
end
