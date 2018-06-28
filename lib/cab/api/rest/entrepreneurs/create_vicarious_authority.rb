# frozen_string_literal: true

module Cab
  module API
    module REST
      module Entrepreneurs
        # Модуль с описанием REST API метода, создающего запись связи между
        # записями индивидуального предпринимателя, его представителя и
        # документа, подтверждающего полномочия представителя
        module CreateVicariousAuthority
          # Регистрация в контроллере необходимых путей
          # @param [Cab::API::REST::Controller] controller
          #   контроллер
          def self.registered(controller)
            # Создаёт запись связи между записями индивидуального
            # предпринимателя, его представителя и документа, подтверждающего
            # полномочия представителя
            # @param [Hash] params
            #   ассоциативный массив, структура которого описана JSON-схемой
            #   {Actions::Entrepreneurs::CreateVicariousAuthority::PARAMS_SCHEMA}
            # @return [Status]
            #   204
            controller.post '/entrepreneurs/:id/vicarious_authority' do |id|
              Actions::Entrepreneurs
                .create_vicarious_authority(id, request_body)
              status :no_content
            end
          end
        end

        Controller.register CreateVicariousAuthority
      end
    end
  end
end
