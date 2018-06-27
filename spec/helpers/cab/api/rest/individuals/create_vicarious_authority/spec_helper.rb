# frozen_string_literal: true

module Cab
  need 'actions/individuals/create_vicarious_authority/result_schema'

  module API
    module REST
      module Individuals
        module CreateVicariousAuthority
          # Вспомогательный модуль, предназначенный для подключения к тестам
          # REST API метода, описанного в содержащем модуле
          module SpecHelper
            # Возвращает JSON-схему тела ответа
            # @return [Object]
            #   JSON-схема тела ответа
            def schema
              Actions::Individuals::CreateVicariousAuthority::RESULT_SCHEMA
            end
          end
        end
      end
    end
  end
end