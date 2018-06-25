# frozen_string_literal: true

module Cab
  module API
    module REST
      module Applicants
        # Модуль с описанием REST API метода, обновляющего поля записей
        # заявителей
        module Update
          # Регистрация в контроллере необходимых путей
          # @param [Cab::API::REST::Controller] controller
          #   контроллер
          def self.registered(controller)
            # Обновляет поля записи заявителя и возвращает информацию об
            # обновлённой записи
            # @param [Hash] params
            #   ассоциативный массив, структура которого описана JSON-схемой
            #   {Actions::Applicants::Update::PARAMS_SCHEMA}
            # @return [Hash]
            #   ассоциативный массив, структура которого описана JSON-схемой
            #   {Actions::Applicants::Update::RESULT_SCHEMA}
            # @return [Status]
            #   200
            controller.put '/applicants/:id' do |id|
              content = Actions::Applicants.update(id, request_body)
              status :ok
              body Oj.dump(content)
            end
          end
        end

        Controller.register Update
      end
    end
  end
end
