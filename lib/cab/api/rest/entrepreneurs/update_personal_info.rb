# frozen_string_literal: true

module Cab
  module API
    module REST
      module Entrepreneurs
        # Модуль с описанием REST API метода, обновляющего персональные данные
        # записей индивидуальных предпринимателей
        module UpdatePersonalInfo
          # Регистрация в контроллере необходимых путей
          # @param [Cab::API::REST::Controller] controller
          #   контроллер
          def self.registered(controller)
            # Обновляет персональные данные в записи индивидуального
            # предпринимателя и возвращает информацию об обновлённой записи
            # @param [Hash] params
            #   ассоциативный массив, структура которого описана JSON-схемой
            #   {Actions::Entrepreneurs::UpdatePersonalInfo::PARAMS_SCHEMA}
            # @return [Hash]
            #   ассоциативный массив, структура которого описана JSON-схемой
            #   {Actions::Entrepreneurs::UpdatePersonalInfo::RESULT_SCHEMA}
            # @return [Status]
            #   200
            controller.put '/entrepreneurs/:id/personal' do |id|
              content =
                Actions::Entrepreneurs.update_personal_info(id, request_body)
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
