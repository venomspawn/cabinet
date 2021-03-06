# frozen_string_literal: true

module Cab
  need 'actions/uuid_format'

  module Actions
    module Files
      class Create
        # Схема результатов действия
        RESULT_SCHEMA = {
          type: :object,
          properties: {
            id: {
              type: :string,
              pattern: Cab::Actions::UUID_FORMAT
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
