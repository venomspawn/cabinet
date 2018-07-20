# frozen_string_literal: true

module Cab
  need 'actions/uuid_format'

  module Actions
    module Individuals
      class Create
        # JSON-схема параметров действия
        PARAMS_SCHEMA = {
          type: :object,
          properties: {
            first_name: {
              type: :string
            },
            last_name: {
              type: :string
            },
            middle_name: {
              type: %i[string null]
            },
            birth_place: {
              type: :string
            },
            birth_date: {
              type: :string,
              pattern: /\A[0-9]{1,2}.[0-9]{1,2}.[0-9]{4}\z/
            },
            sex: {
              type: :string,
              enum: %w[male female]
            },
            citizenship: {
              type: :string,
              enum: %w[russian foreign absent]
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
            },
            identity_document: {
              type: :object,
              properties: {
                type: {
                  type: :string,
                  enum: %w[
                    passport_rf
                    international_passport
                    seaman_passport
                    officer_identity_document
                    soldier_identity_document
                    temporary_identity_card
                    birth_certificate
                    foreign_citizen_passport
                    residence
                    temporary_residence
                    refugee_certificate
                    certificate_of_temporary_asylum_rf
                  ]
                },
                number: {
                  type: %i[string null]
                },
                series: {
                  type: :string
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
                file_id: {
                  type: :string,
                  pattern: UUID_FORMAT
                }
              },
              required: %i[
                type
                series
                issued_by
                issue_date
                file_id
              ]
            },
            agreement_id: {
              type: :string,
              pattern: UUID_FORMAT
            },
            spokesman: {
              type: %i[object null],
              properties: {
                id: {
                  type: :string,
                  pattern: UUID_FORMAT
                },
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
                file_id: {
                  type: :string,
                  pattern: UUID_FORMAT
                }
              },
              required: %i[
                id
                title
                issued_by
                issue_date
                file_id
              ]
            }
          },
          required: %i[
            first_name
            last_name
            birth_place
            birth_date
            sex
            citizenship
            residential_address
            identity_document
            agreement_id
          ]
        }.freeze
      end
    end
  end
end
