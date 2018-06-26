# frozen_string_literal: true

module Cab
  need 'actions/documents/update/result_schema'

  module API
    module REST
      module Documents
        module Update
          # Вспомогательный модуль, предназначенный для подключения к тестам
          # REST API метода, описанного в содержащем модуле
          module SpecHelper
            # Возвращает JSON-схему тела ответа
            # @return [Object]
            #   JSON-схема тела ответа
            def schema
              Actions::Documents::Update::RESULT_SCHEMA
            end
          end
        end
      end
    end
  end
end
