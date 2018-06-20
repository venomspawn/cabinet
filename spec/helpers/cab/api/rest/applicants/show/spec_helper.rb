# frozen_string_literal: true

module Cab
  need 'actions/applicants/show/result_schema'

  module API
    module REST
      module Applicants
        module Show
          # Вспомогательный модуль, предназначенный для подключения к тестам
          # действия содержащего класса
          module SpecHelper
            # Возвращает JSON-схему результирующего действия
            # @return [Object]
            #   JSON-схема результирующего действия
            def schema
              Actions::Applicants::Show::RESULT_SCHEMA
            end
          end
        end
      end
    end
  end
end
