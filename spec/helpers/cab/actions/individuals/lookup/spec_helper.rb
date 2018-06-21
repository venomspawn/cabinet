# frozen_string_literal: true

module Cab
  need 'actions/individuals/lookup/result_schema'

  module Actions
    module Individuals
      class Lookup
        # Вспомогательный модуль, предназначенный для подключения к тестам
        # действия содержащего класса
        module SpecHelper
          # Возвращает JSON-схему результирующего действия
          # @return [Object]
          #   JSON-схема результирующего действия
          def schema
            RESULT_SCHEMA
          end

          # Возвращает список значений свойства `id` ассоциативных массивов,
          # образующих предоставленный список
          # @param [Array<Hash{:id => Object}>]
          #   список ассоциативных массивов
          # @return [Array]
          #   результирующий список
          def ids(list)
            list.map { |hash| hash[:id] }
          end
        end
      end
    end
  end
end
