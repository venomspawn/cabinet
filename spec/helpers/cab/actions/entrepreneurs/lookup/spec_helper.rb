# frozen_string_literal: true

module Cab
  need 'actions/entrepreneurs/lookup/result_schema'

  module Actions
    module Entrepreneurs
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

          # Создаёт список записей индивидуальных предпринимателей и возвращает
          # список созданных записей
          # @param [Integer] count
          #   количество записей
          # @param [Hash] traits
          #   ассоциативный массив атрибутов физических лиц, к записям которых
          #   прикрепляются индивидуальных предпринимателей
          # @return [Array]
          #   результирующий список записей
          def create_entrepreneurs(count, traits = {})
            Array.new(count) do
              individual = FactoryBot.create(:individual, traits)
              FactoryBot.create(:entrepreneur, individual_id: individual.id)
            end
          end
        end
      end
    end
  end
end
