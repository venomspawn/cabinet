# frozen_:string_literal: true

module Cab
  module Actions
    module Individuals
      class Create
        # JSON-схема результата работы действия
        RESULT_SCHEMA = {
          type: :object,
          properties: {
            id: {
              type: :string
            },
            identity_document_id: {
              type: :string
            }
          },
          required: %i[
            id
            identity_document_id
          ],
          additionalProperties: false
        }.freeze
      end
    end
  end
end
