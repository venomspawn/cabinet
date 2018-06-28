# frozen_string_literal: true

module Cab
  module Actions
    module Entrepreneurs
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
                    enum: %w[entrepreneur]
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
                  inn: {
                    type: %i[null string]
                  }
                },
                required: %i[
                  client_type
                  id
                  first_name
                  last_name
                  middle_name
                  birth_place
                  birth_date
                  inn
                ],
                additionalProperties: false
              }
            },
            without_last_name: {
              type: :array,
              items: {
                type: :object,
                properties: {
                  client_type: {
                    type: :string,
                    enum: %w[entrepreneur]
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
                  inn: {
                    type: %i[null string]
                  }
                },
                required: %i[
                  client_type
                  id
                  first_name
                  last_name
                  middle_name
                  birth_place
                  birth_date
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
                    enum: %w[individual entrepreneur]
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
                  inn: {
                    type: %i[null string]
                  }
                },
                required: %i[
                  client_type
                  id
                  first_name
                  last_name
                  middle_name
                  birth_place
                  birth_date
                  inn
                ],
                additionalProperties: false
              }
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
