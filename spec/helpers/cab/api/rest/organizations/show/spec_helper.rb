# frozen_string_literal: true

module Cab
  need 'actions/organizations/show/result_schema'

  module API
    module REST
      module Organizations
        module Show
          # Вспомогательный модуль, предназначенный для подключения к тестам
          # REST API метода, описанного в содержащем модуле
          module SpecHelper
            # Возвращает JSON-схему тела ответа
            # @return [Object]
            #   JSON-схема тела ответа
            def schema
              Actions::Organizations::Show::RESULT_SCHEMA
            end
          end
        end
      end
    end
  end
end
