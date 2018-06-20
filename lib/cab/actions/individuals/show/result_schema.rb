# frozen_:string_literal: true

module Cab
  module Actions
    module Individuals
      class Show
        # JSON-схема результата работы действия
        RESULT_SCHEMA = {
          type: :object,
          properties: {
            client_type: {
              enum: %w[individual]
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
            sex: {
              type: :string,
              enum: %w[male female]
            },
            citizenship: {
              type: :string,
              enum: %w[russian foreign absent]
            },
            inn: {
              type: %i[null string]
            },
            snils: {
              type: %i[null string]
            },
            registration_address: {
            },
            residential_address: {
              type: %i[string number object array boolean]
            },
            identity_documents: {
              type: :array,
              items: {
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
                    type: %i[null string]
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
                    type: %i[null string]
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
                      ],
                      additionalProperties: false
                    }
                  }
                },
                required: %i[
                  type
                  number
                  series
                  issued_by
                  issue_date
                  due_date
                  files
                ],
                additionalProperties: false
              },
              minItems: 1
            },
            consent_to_processing: {
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
                ],
                additionalProperties: false
              }
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
            sex
            citizenship
            inn
            snils
            registration_address
            residential_address
          ],
          additionalProperties: false
        }.freeze
      end
    end
  end
end