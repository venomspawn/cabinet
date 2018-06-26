# frozen_:string_literal: true

module Cab
  module Actions
    module Documents
      class Update
        # JSON-схема результата работы действия
        RESULT_SCHEMA = {
          type: :array,
          items: {
            type: :object,
            properties: {
              content: {
                type: :string
              }
            },
            required: %i[
              content
            ]
          },
          minItems: 1
        }.freeze
      end
    end
  end
end
