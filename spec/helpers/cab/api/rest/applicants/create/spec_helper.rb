# frozen_string_literal: true

module Cab
  need 'actions/applicants/create/result_schema'

  module API
    module REST
      module Applicants
        module Create
          # Вспомогательный модуль, предназначенный для подключения к тестам
          # REST API метода, описанного в содержащем модуле
          module SpecHelper
            # Возвращает JSON-схему тела ответа
            # @return [Object]
            #   JSON-схема тела ответа
            def schema
              Actions::Applicants::Create::RESULT_SCHEMA
            end
          end
        end
      end
    end
  end
end
