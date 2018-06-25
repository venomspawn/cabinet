# frozen_:string_literal: true

module Cab
  need 'actions/individuals/update/params_schema'
  need 'actions/entrepreneurs/update/params_schema'
  need 'actions/organizations/update/params_schema'

  module Actions
    module Applicants
      class Update
        # JSON-схема параметров действия
        PARAMS_SCHEMA = {
          type: :object,
          properties: {
            individual:   Individuals::Update::PARAMS_SCHEMA,
            entrepreneur: Entrepreneurs::Update::PARAMS_SCHEMA,
            organization: Organizations::Update::PARAMS_SCHEMA
          },
          minProperties: 1,
          maxProperties: 1,
          additionalProperties: false
        }.freeze
      end
    end
  end
end
