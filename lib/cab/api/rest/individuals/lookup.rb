# frozen_string_literal: true

module Cab
  module API
    module REST
      module Individuals
        # Модуль с описанием REST API метода, извлекающего информацию о
        # физических лицах
        module Lookup
          # Регистрация в контроллере необходимых путей
          # @param [Cab::API::REST::Controller] controller
          #   контроллер
          def self.registered(controller)
            # Возвращает информацию о физических лицах
            # @param [Hash] params
            #   ассоциативный массив, структура которого описана JSON-схемой
            #   {Actions::Individuals::Lookup::PARAMS_SCHEMA}
            # @return [Hash]
            #   ассоциативный массив, структура которого описана JSON-схемой
            #   {Actions::Individuals::Lookup::RESULT_SCHEMA}
            # @return [Status]
            #   200
            controller.get '/individuals' do
              content = Actions::Individuals.lookup(params[:lookup_data])
              status :ok
              body Oj.dump(content)
            end
          end
        end

        Controller.register Lookup
      end
    end
  end
end
