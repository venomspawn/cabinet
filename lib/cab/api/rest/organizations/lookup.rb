# frozen_string_literal: true

module Cab
  module API
    module REST
      module Organizations
        # Модуль с описанием REST API метода, извлекающего информацию о
        # юридических лицах
        module Lookup
          # Регистрация в контроллере необходимых путей
          # @param [Cab::API::REST::Controller] controller
          #   контроллер
          def self.registered(controller)
            # Возвращает информацию о юридических лицах
            # @param [Hash] params
            #   ассоциативный массив, структура которого описана JSON-схемой
            #   {Actions::Organizations::Lookup::PARAMS_SCHEMA}
            # @return [Hash]
            #   ассоциативный массив, структура которого описана JSON-схемой
            #   {Actions::Organizations::Lookup::RESULT_SCHEMA}
            # @return [Status]
            #   200
            controller.get '/organizations' do
              lookup_data = Oj.load(params[:lookup_data])
              content = Actions::Organizations.lookup(lookup_data)
              status :ok
              body Oj.dump(content)
            end
          end
        end

        Controller.register Lookup
      end
    end
  end
end
