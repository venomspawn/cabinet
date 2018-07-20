# frozen_string_literal: true

module Cab
  module API
    module REST
      module Organizations
        # Модуль с описанием REST API метода, создающего записи юридических лиц
        module Create
          # Регистрация в контроллере необходимых путей
          # @param [Cab::API::REST::Controller] controller
          #   контроллер
          def self.registered(controller)
            # Создаёт запись юридического лица и возвращает информацию о
            # созданной записи
            # @param [Hash] params
            #   ассоциативный массив, структура которого описана JSON-схемой
            #   {Actions::Organizations::Create::PARAMS_SCHEMA}
            # @return [Hash]
            #   ассоциативный массив, структура которого описана JSON-схемой
            #   {Actions::Organizations::Create::RESULT_SCHEMA}
            # @return [Status]
            #   201
            controller.post '/organizations' do
              content = Actions::Organizations.create(request.body)
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
