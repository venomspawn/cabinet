# frozen_string_literal: true

module Cab
  module API
    module REST
      # Пространство имён модулей с описаниями REST API методов, оперирующих
      # записями физических лиц
      module Individuals
        # Модуль с описанием REST API метода, возвращающего информацию о
        # физических лицах
        module Show
          # Регистрация в контроллере необходимых путей
          # @param [Cab::API::REST::Controller] controller
          #   контроллер
          def self.registered(controller)
            # Возвращает информацию о физическом лице
            # @param [Hash] params
            #   ассоциативный массив, структура которого описана JSON-схемой
            #   {Actions::Individuals::Show::PARAMS_SCHEMA}
            # @return [Hash]
            #   ассоциативный массив, структура которого описана JSON-схемой
            #   {Actions::Individuals::Show::RESULT_SCHEMA}
            # @return [Status]
            #   200
            controller.get '/individuals/:id' do |id|
              content = Actions::Individuals.show(request.GET, id: id)
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
