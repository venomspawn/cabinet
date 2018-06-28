# frozen_:string_literal: true

module Cab
  module Actions
    module Individuals
      class UpdatePersonalInfo
        # JSON-схема результата работы действия
        RESULT_SCHEMA = {
          type: :object,
          properties: {
            identity_document_id: {
              type: :string
            }
          },
          required: %i[
            identity_document_id
          ],
          additionalProperties: false
        }.freeze
      end
    end
  end
end
