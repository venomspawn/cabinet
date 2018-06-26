# frozen_:string_literal: true

module Cab
  need 'actions/individuals/update_personal_info/result_schema'
  need 'actions/entrepreneurs/update_personal_info/result_schema'

  module Actions
    module Applicants
      class UpdatePersonalInfo
        # JSON-схема результата работы действия
        RESULT_SCHEMA = {
          oneOf: [
            Individuals::UpdatePersonalInfo::RESULT_SCHEMA,
            Entrepreneurs::UpdatePersonalInfo::RESULT_SCHEMA
          ]
        }.freeze
      end
    end
  end
end
