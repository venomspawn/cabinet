# frozen_string_literal: true

require 'sinatra/base'

module Cab
  # Пространство имён для API
  module API
    # Пространство имён для REST API
    module REST
      # Класс контроллера REST API, основанный на Sinatra
      class Controller < Sinatra::Base
        # Тип содержимого, возвращаемого REST API методами
        CONTENT_TYPE = 'application/json; charset=utf-8'

        before { content_type CONTENT_TYPE }

        # Возвращает строку с телом запроса
        # @return [String]
        #   строка с телом запроса
        def request_body
          body = request.body
          body.rewind
          body.read
        end
      end
    end
  end
end
