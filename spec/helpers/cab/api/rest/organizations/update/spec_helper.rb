# frozen_string_literal: true

module Cab
  need 'actions/organizations/update/result_schema'

  module API
    module REST
      module Organizations
        module Update
          # Вспомогательный модуль, предназначенный для подключения к тестам
          # REST API метода, описанного в содержащем модуле
          module SpecHelper
            # Возвращает JSON-схему тела ответа
            # @return [Object]
            #   JSON-схема тела ответа
            def schema
              Actions::Organizations::Update::RESULT_SCHEMA
            end
          end
        end
      end
    end
  end
end
