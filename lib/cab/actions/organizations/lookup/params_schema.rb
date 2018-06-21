# frozen_string_literal: true

module Cab
  module Actions
    module Organizations
      class Lookup
        # JSON-схема параметров действия
        PARAMS_SCHEMA = {
          type: :object,
          properties: {
            full_name: {
              type: :string
            },
            inn: {
              type: :string
            },
            legal_address: {
            }
          },
          additionalProperties: false
        }.freeze
      end
    end
  end
end
