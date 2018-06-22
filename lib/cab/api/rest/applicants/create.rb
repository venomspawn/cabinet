# frozen_string_literal: true

module Cab
  module API
    module REST
      module Applicants
        # Модуль с описанием REST API метода, создающего записи заявителей
        module Create
          # Регистрация в контроллере необходимых путей
          # @param [Cab::API::REST::Controller] controller
          #   контроллер
          def self.registered(controller)
            # Создаёт запись заявителя и возвращает информацию о созданной
            # записи
            # @param [Hash] params
            #   ассоциативный массив, структура которого описана JSON-схемой
            #   {Actions::Applicants::Create::PARAMS_SCHEMA}
            # @return [Hash]
            #   ассоциативный массив, структура которого описана JSON-схемой
            #   {Actions::Applicants::Create::RESULT_SCHEMA}
            # @return [Status]
            #   200
            controller.post '/applicants' do
              content = Actions::Applicants.create(request_body)
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
