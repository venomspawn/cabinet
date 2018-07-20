# frozen_string_literal: true

module Cab
  module API
    module REST
      module Entrepreneurs
        # Модуль с описанием REST API метода, обновляющего поля записей
        # индивидуальных предпринимателей
        module Update
          # Регистрация в контроллере необходимых путей
          # @param [Cab::API::REST::Controller] controller
          #   контроллер
          def self.registered(controller)
            # Обновляет поля записи индивидуального предпринимателя
            # @param [Hash] params
            #   ассоциативный массив, структура которого описана JSON-схемой
            #   {Actions::Entrepreneurs::Update::PARAMS_SCHEMA}
            # @return [Status]
            #   200
            controller.put '/entrepreneurs/:id' do |id|
              Actions::Entrepreneurs.update(request.body, id: id)
              status :no_content
            end
          end
        end

        Controller.register Update
      end
    end
  end
end
