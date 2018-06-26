# frozen_string_literal: true

module Cab
  need 'actions/entrepreneurs/update_personal_info/result_schema'

  module Actions
    module Entrepreneurs
      class UpdatePersonalInfo
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
