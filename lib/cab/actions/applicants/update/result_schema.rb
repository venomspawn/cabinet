# frozen_:string_literal: true

module Cab
  need 'actions/individuals/update/result_schema'
  need 'actions/entrepreneurs/update/result_schema'
  need 'actions/organizations/update/result_schema'

  module Actions
    module Applicants
      class Update
        # JSON-схема результата работы действия
        RESULT_SCHEMA = {
          oneOf: [
            Individuals::Update::RESULT_SCHEMA,
            Entrepreneurs::Update::RESULT_SCHEMA,
            Organizations::Update::RESULT_SCHEMA
          ]
        }.freeze
      end
    end
  end
end
