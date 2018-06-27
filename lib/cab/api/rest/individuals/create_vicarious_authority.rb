# frozen_string_literal: true

module Cab
  module API
    module REST
      module Individuals
        # Модуль с описанием REST API метода, создающего запись связи между
        # физическим лицом, его представителем и документом, подтверждающем
        # полномочия представителя
        module CreateVicariousAuthority
          # Регистрация в контроллере необходимых путей
          # @param [Cab::API::REST::Controller] controller
          #   контроллер
          def self.registered(controller)
            # Создаёт запись связи между физическим лицом, его представителем и
            # документом, подтверждающем полномочия представителя, после чего
            # возвращает информацию о созданной записи
            # @param [Hash] params
            #   ассоциативный массив, структура которого описана JSON-схемой
            #   {Actions::Individuals::CreateVicariousAuthority::PARAMS_SCHEMA}
            # @return [Hash]
            #   ассоциативный массив, структура которого описана JSON-схемой
            #   {Actions::Individuals::CreateVicariousAuthority::RESULT_SCHEMA}
            # @return [Status]
            #   200
            controller.post '/individuals/:id/vicarious_authority' do |id|
              content = Actions::Individuals
                        .create_vicarious_authority(id, request_body)
              status :created
              body Oj.dump(content)
            end
          end
        end

        Controller.register CreateVicariousAuthority
      end
    end
  end
end
