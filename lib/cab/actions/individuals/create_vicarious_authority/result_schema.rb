# frozen_:string_literal: true

module Cab
  module Actions
    module Individuals
      class Create
        # JSON-схема результата работы действия
        RESULT_SCHEMA = {
          type: :object,
          properties: {
            applicant_id: {
              type: :string
            },
            spokesman_id: {
              type: :string
            },
            power_of_attorney: {
              type: :object,
              properties: {
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
                files
              ]
            }
          },
          required: %i[
            applicant_id
            spokesman_id
            power_of_attorney
          ]
        }.freeze
      end
    end
  end
end
