# frozen_string_literal: true

module Cab
  need 'actions/uuid_format'

  module Actions
    module Organizations
      class Update
        # JSON-схема параметров действия
        PARAMS_SCHEMA = {
          type: :object,
          properties: {
            id: {
              type: :string,
              pattern: UUID_FORMAT
            },
            full_name: {
              type: :string
            },
            sokr_name: {
              type: %i[string null]
            },
            chief_name: {
              type: :string
            },
            chief_surname: {
              type: :string
            },
            chief_middle_name: {
              type: %i[string null]
            },
            registration_date: {
              type: :string,
              pattern: /\A[0-9]{1,2}.[0-9]{1,2}.[0-9]{4}\z/
            },
            inn: {
              type: :string
            },
            kpp: {
              type: :string
            },
            ogrn: {
              type: :string
            },
            legal_address: {
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
          },
          required: %i[
            id
          ]
        }.freeze
      end
    end
  end
end
