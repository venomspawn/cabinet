# frozen_string_literal: true

# Настройка тестирования контроллера REST API

require 'rack/test'

module Support
  module RackHelper
    include Rack::Test::Methods

    # Тестируемый REST-контроллер
    def app
      Cab::API::REST::Controller
    end
  end
end

RSpec.configure do |config|
  config.include Support::RackHelper
end
