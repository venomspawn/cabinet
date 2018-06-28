# frozen_string_literal: true

module Cab
  module Actions
    module Documents
      class Update
        # JSON-схема параметров действия
        PARAMS_SCHEMA = {
          type: :object,
          property: {
            content: {
              type: :string
            }
          },
          required: %i[
            content
          ]
        }.freeze
      end
    end
  end
end
