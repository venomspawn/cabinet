# frozen_:string_literal: true

module Cab
  module Actions
    module Organizations
      class CreateVicariousAuthority
        # JSON-схема параметров действия
        PARAMS_SCHEMA = {
          type: :object,
          properties: {
            id: {
              type: :string
            },
            power_of_attorney: {
              type: :object,
              properties: {
                title: {
                  type: :string
                },
                number: {
                  type: %i[string null]
                },
                series: {
                  type: %i[string null]
                },
                registry_number: {
                  type: %i[string null]
                },
                issued_by: {
                  type: :string
                },
                issue_date: {
                  type: :string
                },
                due_date: {
                  type: %i[string null]
                },
                files: {
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
                }
              },
              required: %i[
                title
                issued_by
                issue_date
                files
              ]
            }
          },
          required: %i[
            id
            power_of_attorney
          ]
        }.freeze
      end
    end
  end
end
