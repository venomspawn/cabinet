# frozen_string_literal: true

module Cab
  module Models
    # Модель записи связи между записями индивидуальных предпринимателей и их
    # представителей
    # @!attribute created_at
    #   Дата и время создания
    #   @return [Time]
    #     дата и время создания
    # @!attribute spokesman_id
    #   Идентификатор записи представителя
    #   @return [String]
    #     идентификатор записи представителя
    # @!attribute entreprenur_id
    #   Идентификатор записи индивидуального предпринимателя
    #   @return [String]
    #     идентификатор записи индивидуального предпринимателя
    # @!attribute vicarious_authority_id
    #   Идентификатор записи документа, подтверждающего полномочия
    #   представителя
    #   @return [String]
    #     идентификатор записи документа, подтверждающего полномочия
    #     представителя
    class EntrepreneurSpokesman < Sequel::Model
    end
  end
end
