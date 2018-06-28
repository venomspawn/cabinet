# frozen_string_literal: true

module Cab
  module Actions
    module Entrepreneurs
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
          ],
          additionalProperties: false
        }.freeze
      end
    end
  end
end
