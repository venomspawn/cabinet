# frozen_string_literal: true

# Настройка тестирования

require 'rspec'

ENV['RACK_ENV'] = 'test'

RSpec.configure do |config|
  # Исключение поддержки конструкций describe без префикса RSpec.
  config.expose_dsl_globally = false
end

require_relative '../config/app_init'

Cab::Init.run!

Dir["#{Cab.root}/spec/helpers/**/*.rb"].sort.each(&method(:require))
Dir["#{Cab.root}/spec/shared/**/*.rb"].sort.each(&method(:require))
Dir["#{Cab.root}/spec/support/**/*.rb"].sort.each(&method(:require))
