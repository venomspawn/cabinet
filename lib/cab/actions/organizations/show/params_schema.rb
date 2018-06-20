# frozen_string_literal: true

module Cab
  module Actions
    module Organizations
      class Show
        # JSON-схема параметров действия
        PARAMS_SCHEMA = {
          type: :object,
          properties: {
            id: {
              type: :string,
              pattern: /^\d{8}-\d{4}-\d{4}-\d{4}-\d{12}$/
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
