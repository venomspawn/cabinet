# frozen_string_literal: true

module Cab
  need 'actions/uuid_format'

  module Actions
    module Individuals
      class Show
        # JSON-схема параметров действия
        PARAMS_SCHEMA = {
          type: :object,
          properties: {
            id: {
              type: :string,
              pattern: UUID_FORMAT
            },
            extended: {
              type: %i[null boolean string]
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
