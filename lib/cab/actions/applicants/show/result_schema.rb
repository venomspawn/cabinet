# frozen_:string_literal: true

module Cab
  need 'actions/individuals/show/result_schema'
  need 'actions/entrepreneurs/show/result_schema'
  need 'actions/organizations/show/result_schema'

  module Actions
    module Applicants
      class Show
        # JSON-схема результата работы действия
        RESULT_SCHEMA = {
          oneOf: [
            Individuals::Show::RESULT_SCHEMA,
            Entrepreneurs::Show::RESULT_SCHEMA,
            Organizations::Show::RESULT_SCHEMA
          ]
        }.freeze
      end
    end
  end
end
