# frozen_string_literal: true

module Cab
  module API
    module REST
      # Пространство имён модулей с описаниями REST API методов, которые
      # оперируют записями документов, удостоверяющих личность
      module Documents
        # Модуль с описанием REST API метода, который обновляет содержимое
        # файла документа, удостоверяющего личность
        module Update
          # Регистрация в контроллере необходимых путей
          # @param [Cab::API::REST::Controller] controller
          #   контроллер
          def self.registered(controller)
            # Обновляет содержимое файла документа, удостоверяющего личность
            # @param [Hash] params
            #   ассоциативный массив, структура которого описана JSON-схемой
            #   {Actions::Documents::Update::PARAMS_SCHEMA}
            # @return [Status]
            #   204
            controller.put '/documents/:id' do |id|
              Actions::Documents.update(id, request_body)
              status :no_content
            end
          end
        end

        Controller.register Update
      end
    end
  end
end
