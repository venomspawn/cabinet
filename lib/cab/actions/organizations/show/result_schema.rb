# frozen_string_literal: true

module Cab
  module Actions
    module Organizations
      class Show
        # JSON-схема результата работы действия
        RESULT_SCHEMA = {
          type: :object,
          properties: {
            client_type: {
              type: :string,
              enum: %w[organization]
            },
            id: {
              type: :string
            },
            full_name: {
              type: :string
            },
            sokr_name: {
              type: %i[null string]
            },
            chief_name: {
              type: :string
            },
            chief_surname: {
              type: :string
            },
            chief_middle_name: {
              type: %i[null string]
            },
            registration_date: {
              type: :string
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
              type: %i[string number object array boolean]
            },
            actual_address: {
            },
            bank_details: {
            }
          },
          required: %i[
            client_type
            id
            full_name
            sokr_name
            chief_name
            chief_surname
            chief_middle_name
            registration_date
            inn
            kpp
            ogrn
            legal_address
            actual_address
            bank_details
          ],
          additionalProperties: false
        }.freeze
      end
    end
  end
end
