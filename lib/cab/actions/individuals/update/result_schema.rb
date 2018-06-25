# frozen_:string_literal: true

module Cab
  module Actions
    module Individuals
      class Update
        # JSON-схема результата работы действия
        RESULT_SCHEMA = {
          type: :object,
          properties: {
            client_type: {
              type: :string,
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
