# frozen_string_literal: true

module Cab
  need 'actions/applicants/lookup/result_schema'

  module API
    module REST
      module Applicants
        module Lookup
          # Вспомогательный модуль, предназначенный для подключения к тестам
          # действия содержащего класса
          module SpecHelper
            # Возвращает JSON-схему результирующего действия
            # @return [Object]
            #   JSON-схема результирующего действия
            def schema
              Actions::Applicants::Lookup::RESULT_SCHEMA
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
              count.times.map do
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
