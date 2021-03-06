# frozen_string_literal: true

module Cab
  need 'actions/entrepreneurs/lookup/result_schema'

  module API
    module REST
      module Entrepreneurs
        module Lookup
          # Вспомогательный модуль, предназначенный для подключения к тестам
          # REST API метода, описанного в содержащем модуле
          module SpecHelper
            # Возвращает JSON-схему тела ответа
            # @return [Object]
            #   JSON-схема тела ответа
            def schema
              Actions::Entrepreneurs::Lookup::RESULT_SCHEMA
            end

            # Создаёт список записей индивидуальных предпринимателей и
            # возвращает список созданных записей
            # @param [Integer] count
            #   количество записей
            # @param [Hash] traits
            #   ассоциативный массив атрибутов физических лиц, к записям
            #   которых прикрепляются индивидуальных предпринимателей
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
end
