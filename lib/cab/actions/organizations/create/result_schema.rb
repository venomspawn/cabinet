# frozen_:string_literal: true

module Cab
  module Actions
    module Organizations
      class Create
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
            director: {
              type: :string
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
            director
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
