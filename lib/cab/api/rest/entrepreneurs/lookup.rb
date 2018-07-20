# frozen_string_literal: true

module Cab
  module API
    module REST
      module Entrepreneurs
        # Модуль с описанием REST API метода, извлекающего информацию об
        # индивидуальных предпринимателях
        module Lookup
          # Регистрация в контроллере необходимых путей
          # @param [Cab::API::REST::Controller] controller
          #   контроллер
          def self.registered(controller)
            # Возвращает информацию о индивидуальных предпринимателях
            # @param [Hash] params
            #   ассоциативный массив, структура которого описана JSON-схемой
            #   {Actions::Entrepreneurs::Lookup::PARAMS_SCHEMA}
            # @return [Hash]
            #   ассоциативный массив, структура которого описана JSON-схемой
            #   {Actions::Entrepreneurs::Lookup::RESULT_SCHEMA}
            # @return [Status]
            #   200
            controller.get '/entrepreneurs' do
              content = Actions::Entrepreneurs.lookup(params[:lookup_data])
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
