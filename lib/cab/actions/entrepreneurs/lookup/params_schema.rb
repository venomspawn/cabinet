# frozen_string_literal: true

module Cab
  module Actions
    module Entrepreneurs
      class Lookup
        # JSON-схема параметров действия
        PARAMS_SCHEMA = {
          type: :object,
          properties: {
            first_name: {
              type: :string
            },
            middle_name: {
              type: :string
            },
            last_name: {
              type: :string
            },
            birth_date: {
              type: :string,
              pattern: /^[0-9]{1,2}.[0-9]{1,2}.[0-9]{4}$/
            },
            birth_place: {
              type: :string
            },
            inn: {
              type: :string
            },
            snils: {
              type: :string
            }
          },
          additionalProperties: false
        }.freeze
      end
    end
  end
end
