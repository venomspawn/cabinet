# frozen_string_literal: true

module Cab
  need 'actions/documents/update/result_schema'

  module Actions
    module Documents
      class Update
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
