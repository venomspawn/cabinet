# frozen_string_literal: true

module Cab
  module API
    module REST
      module Applicants
        # Модуль с описанием REST API метода, обновляющего персональные данные
        # записей заявителей
        module UpdatePersonalInfo
          # Регистрация в контроллере необходимых путей
          # @param [Cab::API::REST::Controller] controller
          #   контроллер
          def self.registered(controller)
            # Обновляет персональные данные в записи заявителя и возвращает
            # информацию об обновлённой записи
            # @param [Hash] params
            #   ассоциативный массив, структура которого описана JSON-схемой
            #   {Actions::Applicants::UpdatePersonalInfo::PARAMS_SCHEMA}
            # @return [Hash]
            #   ассоциативный массив, структура которого описана JSON-схемой
            #   {Actions::Applicants::UpdatePersonalInfo::RESULT_SCHEMA}
            # @return [Status]
            #   200
            controller.put '/applicants/:id/personal' do |id|
              content =
                Actions::Applicants.update_personal_info(id, request_body)
              status :ok
              body Oj.dump(content)
            end
          end
        end

        Controller.register UpdatePersonalInfo
      end
    end
  end
end
