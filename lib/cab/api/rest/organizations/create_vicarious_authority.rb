# frozen_string_literal: true

module Cab
  module API
    module REST
      module Organizations
        # Модуль с описанием REST API метода, создающего запись связи между
        # записями юридического лица, его представителя и документа,
        # подтверждающего полномочия представителя
        module CreateVicariousAuthority
          # Регистрация в контроллере необходимых путей
          # @param [Cab::API::REST::Controller] controller
          #   контроллер
          def self.registered(controller)
            # Создаёт запись связи между записями юридического лица, его
            # представителя и документа, подтверждающего полномочия
            # представителя, после чего возвращает информацию о созданной
            # записи
            # @param [Hash] params
            #   ассоциативный массив, структура которого описана JSON-схемой
            #   {Actions::Organizations::CreateVicariousAuthority::PARAMS_SCHEMA}
            # @return [Hash]
            #   ассоциативный массив, структура которого описана JSON-схемой
            #   {Actions::Organizations::CreateVicariousAuthority::RESULT_SCHEMA}
            # @return [Status]
            #   201
            controller.post '/organizations/:id/vicarious_authority' do |id|
              content = Actions::Organizations
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
