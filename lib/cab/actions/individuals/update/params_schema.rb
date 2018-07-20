# frozen_string_literal: true

module Cab
  need 'actions/uuid_format'

  module Actions
    module Individuals
      class Update
        # JSON-схема параметров действия
        PARAMS_SCHEMA = {
          type: :object,
          properties: {
            id: {
              type: :string,
              pattern: UUID_FORMAT
            },
            snils: {
              type: %i[string null],
              pattern: /\A[0-9]{3}-[0-9]{3}-[0-9]{3} [0-9]{2}\z/
            },
            inn: {
              type: %i[string null],
              pattern: /\A[0-9]{12}\z/
            },
            registration_address: {
              type: %i[object null],
              properties: {
                zip: {
                  type: %i[string null]
                },
                region: {
                  type: %i[string null]
                },
                sub_region: {
                  type: %i[string null]
                },
                city: {
                  type: %i[string null]
                },
                settlement: {
                  type: %i[string null]
                },
                street: {
                  type: %i[string null]
                },
                house: {
                  type: %i[string null]
                },
                building: {
                  type: %i[string null]
                },
                appartment: {
                  type: %i[string null]
                },
                structure: {
                  type: %i[string null]
                },
                region_code: {
                  type: %i[string null]
                },
                fias: {
                  type: %i[string boolean null]
                }
              }
            },
            residential_address: {
              type: %i[object null],
              properties: {
                zip: {
                  type: %i[string null]
                },
                region: {
                  type: %i[string null]
                },
                sub_region: {
                  type: %i[string null]
                },
                city: {
                  type: %i[string null]
                },
                settlement: {
                  type: %i[string null]
                },
                street: {
                  type: %i[string null]
                },
                house: {
                  type: %i[string null]
                },
                building: {
                  type: %i[string null]
                },
                appartment: {
                  type: %i[string null]
                },
                structure: {
                  type: %i[string null]
                },
                region_code: {
                  type: %i[string null]
                },
                fias: {
                  type: %i[string boolean null]
                }
              }
            }
          },
          required: %i[
            id
          ]
        }.freeze
      end
    end
  end
end
