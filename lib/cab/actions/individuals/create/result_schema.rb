# frozen_string_literal: true

module Cab
  need 'actions/uuid_format'

  module Actions
    module Individuals
      class Create
        # JSON-схема результата работы действия
        RESULT_SCHEMA = {
          type: :object,
          properties: {
            id: {
              type: :string,
              pattern: UUID_FORMAT
            },
            identity_document_id: {
              type: :string,
              pattern: UUID_FORMAT
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
