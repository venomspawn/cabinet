# frozen_:string_literal: true

module Cab
  module Actions
    module Individuals
      class Lookup
        # JSON-схема результата работы действия
        RESULT_SCHEMA = {
          definitions: {
            individuals: {
              type: :array,
              items: {
                type: :object,
                properties: {
                  client_type: {
                    type: :string,
                    enum: %w[individual]
                  },
                  id: {
                    type: :string
                  },
                  first_name: {
                    type: :string
                  },
                  last_name: {
                    type: :string
                  },
                  middle_name: {
                    type: %i[null string]
                  },
                  birth_place: {
                    type: :string
                  },
                  birth_date: {
                    type: :string
                  },
                },
                required: %i[
                  client_type
                  id
                  first_name
                  last_name
                  middle_name
                  birth_place
                  birth_date
                ],
                additionalProperties: false
              }
            }
          },
          type: :object,
          properties: {
            exact: {
              '$ref': '#/definitions/individuals'
            },
            without_last_name: {
              '$ref': '#/definitions/individuals'
            },
            fuzzy: {
              '$ref': '#/definitions/individuals'
            }
          },
          required: %i[
            exact
            without_last_name
            fuzzy
          ],
          additionalProperties: false
        }.freeze
      end
    end
  end
end
