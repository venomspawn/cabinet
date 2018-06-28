# frozen_string_literal: true

module Cab
  module API
    module REST
      module Individuals
        # Модуль с описанием REST API метода, обновляющего поля записей
        # физических лиц
        module Update
          # Регистрация в контроллере необходимых путей
          # @param [Cab::API::REST::Controller] controller
          #   контроллер
          def self.registered(controller)
            # Обновляет поля записи физического лица
            # @param [Hash] params
            #   ассоциативный массив, структура которого описана JSON-схемой
            #   {Actions::Individuals::Update::PARAMS_SCHEMA}
            # @return [Status]
            #   204
            controller.put '/individuals/:id' do |id|
              Actions::Individuals.update(id, request_body)
              status :no_content
            end
          end
        end

        Controller.register Update
      end
    end
  end
end
