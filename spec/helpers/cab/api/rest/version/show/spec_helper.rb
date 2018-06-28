# frozen_string_literal: true

module Cab
  module API
    module REST
      module Version
        module Show
          # Вспомогательный модуль, предназначенный для включения в тесты
          # содержащего класса действия
          module SpecHelper
            # JSON-схема результата действия
            RESULT_SCHEMA = {
              type: :object,
              properties: {
                version: {
                  type: :string
                },
                hostname: {
                  type: :string
                }
              },
              required: %i[
                version
                hostname
              ],
              additionalProperties: false
            }.freeze

            # Возвращает JSON-схему результата действия
            # @return [Object]
            #   JSON-схема результата действия
            def schema
              RESULT_SCHEMA
            end
          end
        end
      end
    end
  end
end
