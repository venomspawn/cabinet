# frozen_string_literal: true

module Cab
  need 'actions/individuals/lookup/params_schema'
  need 'actions/entrepreneurs/lookup/params_schema'
  need 'actions/organizations/lookup/params_schema'

  module Actions
    module Applicants
      class Lookup
        # JSON-схема параметров действия
        PARAMS_SCHEMA = {
          type: :object,
          properties: {
            individual:   Individuals::Lookup::PARAMS_SCHEMA,
            entrepreneur: Entrepreneurs::Lookup::PARAMS_SCHEMA,
            organization: Organizations::Lookup::PARAMS_SCHEMA
          },
          minProperties: 1,
          maxProperties: 1,
          additionalProperties: false
        }.freeze
      end
    end
  end
end
