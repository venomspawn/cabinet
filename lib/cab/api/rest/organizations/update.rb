# frozen_string_literal: true

module Cab
  module API
    module REST
      module Organizations
        # Модуль с описанием REST API метода, обновляющего поля записей
        # юридических лиц
        module Update
          # Регистрация в контроллере необходимых путей
          # @param [Cab::API::REST::Controller] controller
          #   контроллер
          def self.registered(controller)
            # Обновляет поля записи юридического лица
            # @param [Hash] params
            #   ассоциативный массив, структура которого описана JSON-схемой
            #   {Actions::Organizations::Update::PARAMS_SCHEMA}
            # @return [Status]
            #   204
            controller.put '/organizations/:id' do |id|
              Actions::Organizations.update(request.body, id: id)
              status :no_content
            end
          end
        end

        Controller.register Update
      end
    end
  end
end
