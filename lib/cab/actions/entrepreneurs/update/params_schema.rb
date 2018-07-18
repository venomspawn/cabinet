# frozen_string_literal: true

module Cab
  module Actions
    module Entrepreneurs
      class Update
        # JSON-схема параметров действия
        PARAMS_SCHEMA = {
          type: :object,
          properties: {
            snils: {
              type: %i[string null],
              pattern: /\A[0-9]{3}-[0-9]{3}-[0-9]{3} [0-9]{2}\z/
            },
            inn: {
              type: %i[string null],
              pattern: /\A[0-9]{12}\z/
            },
            commercial_name: {
              type: %i[string null]
            },
            ogrn: {
              type: :string,
              pattern: /\A[0-9]{15}\z/
            },
            registration_address: {
              type: :object,
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
            actual_address: {
              type: :object,
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
            bank_details: {
              type: %i[object null],
              properties: {
                bik: {
                  type: %i[string null]
                },
                account: {
                  type: %i[string null]
                },
                corr_account: {
                  type: %i[string null]
                },
                name: {
                  type: %i[string null]
                }
              }
            }
          }
        }.freeze
      end
    end
  end
end
