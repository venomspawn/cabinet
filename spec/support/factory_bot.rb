# frozen_string_literal: true

# Файл поддержки библиотеки factory_bot

require 'factory_bot'

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
end

FactoryBot.definition_file_paths = ["#{Cab.root}/spec/factories/"]
FactoryBot.find_definitions
