# frozen_string_literal: true

module Cab
  module Actions
    module Entrepreneurs
      class UpdatePersonalInfo
        # JSON-схема результата работы действия
        RESULT_SCHEMA = {
          type: :object,
          properties: {
            identity_document_id: {
              type: :string,
              pattern: UUID_FORMAT
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
