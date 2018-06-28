# frozen_string_literal: true

module Cab
  module Actions
    module Organizations
      class Lookup
        # JSON-схема результата работы действия
        RESULT_SCHEMA = {
          type: :object,
          properties: {
            exact: {
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
            },
            without_inn: {
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
            },
            fuzzy: {
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
