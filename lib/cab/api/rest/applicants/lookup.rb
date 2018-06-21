# frozen_string_literal: true

module Cab
  module API
    module REST
      module Applicants
        # Модуль с описанием REST API метода, извлекающего информацию о
        # заявителях
        module Lookup
          # Регистрация в контроллере необходимых путей
          # @param [Cab::API::REST::Controller] controller
          #   контроллер
          def self.registered(controller)
            # Возвращает информацию о заявителе
            # @param [Hash] params
            #   ассоциативный массив, структура которого описана JSON-схемой
            #   {Actions::Applicants::Lookup::PARAMS_SCHEMA}
            # @return [Hash]
            #   ассоциативный массив, структура которого описана JSON-схемой
            #   {Actions::Applicants::Lookup::RESULT_SCHEMA}
            # @return [Status]
            #   200
            controller.get '/applicants' do
              lookup_data = Oj.load(params[:lookup_data])
              content = Actions::Applicants.lookup(lookup_data)
              status 200
              body Oj.dump(content)
            end
          end
        end

        Controller.register Lookup
      end
    end
  end
end
