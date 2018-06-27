# frozen_string_literal: true

module Cab
  need 'actions/organizations/create_vicarious_authority/result_schema'

  module Actions
    module Organizations
      class CreateVicariousAuthority
        # Вспомогательный модуль, предназначенный для подключения к тестам
        # действия содержащего класса
        module SpecHelper
          # Возвращает JSON-схему результирующего действия
          # @return [Object]
          #   JSON-схема результирующего действия
          def schema
            RESULT_SCHEMA
          end
        end
      end
    end
  end
end
