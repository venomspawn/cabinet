# frozen_:string_literal: true

module Cab
  module Actions
    module Organizations
      class Lookup
        # JSON-схема результата работы действия
        RESULT_SCHEMA = {
          definitions: {
            organizations: {
              type: :array,
              items: {
                type: :object,
                properties: {
                  client_type: {
                    type: :string,
                    enum: %w[organization]
                  },
                  id: {
                    type: :string
                  },
                  full_name: {
                    type: :string
                  },
                  inn: {
                    type: :string
                  }
                },
                required: %i[
                  client_type
                  id
                  full_name
                  inn
                ],
                additionalProperties: false
              }
            }
          },
          type: :object,
          properties: {
            exact: {
              '$ref': '#/definitions/organizations'
            },
            without_inn: {
              '$ref': '#/definitions/organizations'
            },
            fuzzy: {
              '$ref': '#/definitions/organizations'
            }
          },
          required: %i[
            exact
            without_inn
            fuzzy
          ],
          additionalProperties: false
        }.freeze
      end
    end
  end
end
