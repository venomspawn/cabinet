# frozen_string_literal: true

module Cab
  need 'actions/uuid_format'

  module Actions
    module Files
      class Update
        # JSON-схема параметров действия
        PARAMS_SCHEMA = {
          type: :object,
          properties: {
            id: {
              type: :string,
              pattern: UUID_FORMAT
            },
            content: {
              not: { type: :null }
            }
          },
          required: %i[
            id
            content
          ],
          additionalProperties: false
        }.freeze
      end
    end
  end
end
