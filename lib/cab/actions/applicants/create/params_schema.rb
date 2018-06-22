# frozen_:string_literal: true

module Cab
  need 'actions/individuals/create/params_schema'
  need 'actions/entrepreneurs/create/params_schema'
  need 'actions/organizations/create/params_schema'

  module Actions
    module Applicants
      class Create
        # JSON-схема параметров действия
        PARAMS_SCHEMA = {
          type: :object,
          properties: {
            individual:   Individuals::Create::PARAMS_SCHEMA,
            entrepreneur: Entrepreneurs::Create::PARAMS_SCHEMA,
            organization: Organizations::Create::PARAMS_SCHEMA
          },
          minProperties: 1,
          maxProperties: 1,
          additionalProperties: false
        }.freeze
      end
    end
  end
end
