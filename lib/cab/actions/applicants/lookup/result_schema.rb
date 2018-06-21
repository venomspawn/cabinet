# frozen_:string_literal: true

module Cab
  need 'actions/individuals/lookup/result_schema'
  need 'actions/entrepreneurs/lookup/result_schema'
  need 'actions/organizations/lookup/result_schema'

  module Actions
    module Applicants
      class Lookup
        # JSON-схема результата работы действия
        RESULT_SCHEMA = {
          oneOf: [
            Individuals::Lookup::RESULT_SCHEMA,
            Entrepreneurs::Lookup::RESULT_SCHEMA,
            Organizations::Lookup::RESULT_SCHEMA,
          ]
        }.freeze
      end
    end
  end
end
