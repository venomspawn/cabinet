# frozen_string_literal: true

module Cab
  module API
    module REST
      module Files
        # Модуль с методом REST API, который обновляет содержимое файла
        module Update
          # Регистрация в контроллере необходимых путей
          # @param [Cab::API::REST::Controller] controller
          #   контроллер
          def self.registered(controller)
            # Обновляет содержимое файла
            # @return [Status]
            #   204
            controller.put '/files/:id' do |id|
              Actions::Files.update(id: id, content: request_body)
              status :no_content
            end
          end
        end

        Controller.register Update
      end
    end
  end
end
