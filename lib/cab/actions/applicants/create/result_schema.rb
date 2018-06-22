# frozen_:string_literal: true

module Cab
  need 'actions/individuals/create/result_schema'
  need 'actions/entrepreneurs/create/result_schema'
  need 'actions/organizations/create/result_schema'

  module Actions
    module Applicants
      class Create
        # JSON-схема результата работы действия
        RESULT_SCHEMA = {
          oneOf: [
            Individuals::Create::RESULT_SCHEMA,
            Entrepreneurs::Create::RESULT_SCHEMA,
            Organizations::Create::RESULT_SCHEMA
          ]
        }.freeze
      end
    end
  end
end
