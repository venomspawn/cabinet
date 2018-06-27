# frozen_:string_literal: true

module Cab
  module Actions
    module Individuals
      class CreateVicariousAuthority
        # JSON-схема параметров действия
        PARAMS_SCHEMA = {
          type: :object,
          properties: {
            spokesman_id: {
              type: :string
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
            content: {
              type: :string
            }
          },
          required: %i[
            spokesman_id
            title
            issued_by
            issue_date
            content
          ]
        }.freeze
      end
    end
  end
end
