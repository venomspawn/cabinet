# frozen_string_literal: true

module Cab
  module API
    module REST
      # Пространство имён модулей с описаниями REST API методов, оперирующих
      # записями юридических лиц
      module Organizations
        # Модуль с описанием REST API метода, возвращающего информацию о
        # юридических лицах
        module Show
          # Регистрация в контроллере необходимых путей
          # @param [Cab::API::REST::Controller] controller
          #   контроллер
          def self.registered(controller)
            # Возвращает информацию о юридическом лице
            # @param [Hash] params
            #   ассоциативный массив, структура которого описана JSON-схемой
            #   {Actions::Organizations::Show::PARAMS_SCHEMA}
            # @return [Hash]
            #   ассоциативный массив, структура которого описана JSON-схемой
            #   {Actions::Organizations::Show::RESULT_SCHEMA}
            # @return [Status]
            #   200
            controller.get '/organizations/:id' do |id|
              content = Actions::Organizations.show(id: id)
              status :ok
              body Oj.dump(content)
            end
          end
        end

        Controller.register Show
      end
    end
  end
end
