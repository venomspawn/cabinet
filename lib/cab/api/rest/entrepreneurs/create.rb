# frozen_string_literal: true

module Cab
  module API
    module REST
      module Entrepreneurs
        # Модуль с описанием REST API метода, создающего записи индивидуальных
        # предпринимателей
        module Create
          # Регистрация в контроллере необходимых путей
          # @param [Cab::API::REST::Controller] controller
          #   контроллер
          def self.registered(controller)
            # Создаёт запись индивидуального предпринимателя и возвращает
            # информацию о созданной записи
            # @param [Hash] params
            #   ассоциативный массив, структура которого описана JSON-схемой
            #   {Actions::Entrepreneurs::Create::PARAMS_SCHEMA}
            # @return [Hash]
            #   ассоциативный массив, структура которого описана JSON-схемой
            #   {Actions::Entrepreneurs::Create::RESULT_SCHEMA}
            # @return [Status]
            #   201
            controller.post '/entrepreneurs' do
              content = Actions::Entrepreneurs.create(request_body)
              status :created
              body Oj.dump(content)
            end
          end
        end

        Controller.register Create
      end
    end
  end
end
