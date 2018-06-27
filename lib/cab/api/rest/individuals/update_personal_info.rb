# frozen_string_literal: true

module Cab
  module API
    module REST
      module Individuals
        # Модуль с описанием REST API метода, обновляющего персональные данные
        # записей физических лиц
        module UpdatePersonalInfo
          # Регистрация в контроллере необходимых путей
          # @param [Cab::API::REST::Controller] controller
          #   контроллер
          def self.registered(controller)
            # Обновляет персональные данные в записи физического лица и
            # возвращает информацию о созданном документе, удостоверяющем
            # личность
            # @param [Hash] params
            #   ассоциативный массив, структура которого описана JSON-схемой
            #   {Actions::Individuals::UpdatePersonalInfo::PARAMS_SCHEMA}
            # @return [Hash]
            #   ассоциативный массив, структура которого описана JSON-схемой
            #   {Actions::Individuals::UpdatePersonalInfo::RESULT_SCHEMA}
            # @return [Status]
            #   201
            controller.put '/individuals/:id/personal' do |id|
              content =
                Actions::Individuals.update_personal_info(id, request_body)
              status :created
              body Oj.dump(content)
            end
          end
        end

        Controller.register UpdatePersonalInfo
      end
    end
  end
end
