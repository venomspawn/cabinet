# frozen_:string_literal: true

module Cab
  module Actions
    module Individuals
      class UpdatePersonalInfo
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
              pattern: /^[0-9]{1,2}.[0-9]{1,2}.[0-9]{4}$/
            },
            sex: {
              type: :string,
              enum: %w[male female]
            },
            citizenship: {
              type: :string,
              enum: %w[russian foreign absent]
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
                type
                series
                issued_by
                issue_date
                files
              ]
            }
          },
          required: %i[
            identity_document
          ]
        }.freeze
      end
    end
  end
end