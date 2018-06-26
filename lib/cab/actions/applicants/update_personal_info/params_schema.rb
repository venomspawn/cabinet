# frozen_:string_literal: true

module Cab
  need 'actions/individuals/update_personal_info/params_schema'
  need 'actions/entrepreneurs/update_personal_info/params_schema'

  module Actions
    module Applicants
      class UpdatePersonalInfo
        # JSON-схема параметров действия
        PARAMS_SCHEMA = {
          type: :object,
          properties: {
            individual:   Individuals::UpdatePersonalInfo::PARAMS_SCHEMA,
            entrepreneur: Entrepreneurs::UpdatePersonalInfo::PARAMS_SCHEMA
          },
          minProperties: 1,
          maxProperties: 1,
          additionalProperties: false
        }.freeze
      end
    end
  end
end
