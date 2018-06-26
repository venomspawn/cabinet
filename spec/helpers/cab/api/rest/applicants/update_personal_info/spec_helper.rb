# frozen_string_literal: true

module Cab
  need 'actions/applicants/update_personal_info/result_schema'

  module API
    module REST
      module Applicants
        module UpdatePersonalInfo
          # Вспомогательный модуль, предназначенный для подключения к тестам
          # REST API метода, описанного в содержащем модуле
          module SpecHelper
            # Возвращает JSON-схему тела ответа
            # @return [Object]
            #   JSON-схема тела ответа
            def schema
              Actions::Applicants::UpdatePersonalInfo::RESULT_SCHEMA
            end
          end
        end
      end
    end
  end
end
