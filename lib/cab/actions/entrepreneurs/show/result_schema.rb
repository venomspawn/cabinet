# frozen_string_literal: true

module Cab
  need 'actions/uuid_format'

  module Actions
    module Entrepreneurs
      class Show
        # JSON-схема результата работы действия
        RESULT_SCHEMA = {
          type: :object,
          properties: {
            client_type: {
              type: :string,
              enum: %w[entrepreneur]
            },
            id: {
              type: :string,
              pattern: UUID_FORMAT
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
            commercial_name: {
              type: %i[null string]
            },
            ogrn: {
              type: :string
            },
            registration_address: {
            },
            actual_address: {
              type: %i[string number object array boolean]
            },
            bank_details: {
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
                  file_id: {
                    type: :string,
                    pattern: UUID_FORMAT
                  }
                },
                required: %i[
                  type
                  number
                  series
                  issued_by
                  issue_date
                  due_date
                  file_id
                ],
                additionalProperties: false
              },
              minItems: 1
            },
            agreement_id: {
              type: :string,
              pattern: UUID_FORMAT
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
            commercial_name
            ogrn
            registration_address
            actual_address
            bank_details
          ],
          additionalProperties: false
        }.freeze
      end
    end
  end
end
