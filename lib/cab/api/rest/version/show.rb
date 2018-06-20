# frozen_string_literal: true

module Cab
  need 'version'

  module API
    module REST
      # Пространство имён модулей с описаниями REST API методов, оперирующих
      # версией сервиса
      module Version
        # Модуль с описанием REST API метода, возвращающего информацию о версии
        # сервиса
        module Show
          # Содержимое результата запроса на версию сервиса
          BODY = Oj.dump(version: Cab::VERSION, hostname: `hostname`.strip)

          # Регистрация в контроллере необходимых путей
          # @param [Cab::API::REST::Controller] controller
          #   контроллер
          def self.registered(controller)
            # Возвращает информацию о версии сервиса
            # @return [Hash]
            #   ассоциативный массив с информацией о версии
            # @return [Status]
            #   200
            controller.get '/version' do
              status 200
              body BODY
            end
          end
        end

        Controller.register Show
      end
    end
  end
end
