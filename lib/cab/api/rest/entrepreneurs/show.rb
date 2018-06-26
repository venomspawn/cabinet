# frozen_string_literal: true

module Cab
  module API
    module REST
      # Пространство имён модулей с описаниями REST API методов, оперирующих
      # записями индивидуальных предпринимателей
      module Entrepreneurs
        # Модуль с описанием REST API метода, возвращающего информацию об
        # индивидуальном предпринимателе
        module Show
          # Регистрация в контроллере необходимых путей
          # @param [Cab::API::REST::Controller] controller
          #   контроллер
          def self.registered(controller)
            # Возвращает информацию об индивидуальном предпринимателе
            # @param [Hash] params
            #   ассоциативный массив, структура которого описана JSON-схемой
            #   {Actions::Entrepreneurs::Show::PARAMS_SCHEMA}
            # @return [Hash]
            #   ассоциативный массив, структура которого описана JSON-схемой
            #   {Actions::Entrepreneurs::Show::RESULT_SCHEMA}
            # @return [Status]
            #   200
            controller.get '/entrepreneurs/:id' do |id|
              extended = params[:extended]
              content = Actions::Entrepreneurs.show(id: id, extended: extended)
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
