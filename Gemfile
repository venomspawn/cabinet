# frozen_string_literal: true

source 'http://repo.it2.vm/repository/gem-group'

gem 'activesupport'
gem 'dotenv'
gem 'json-schema'
gem 'mysql2'
gem 'oj'
gem 'rake'
gem 'rest-client'
gem 'sequel'
gem 'sequel_pg'
gem 'sinatra'
gem 'thin'

group :development, :test do
  gem 'awesome_print'
  gem 'factory_bot'
  gem 'rspec'
  gem 'yard'
  gem 'yard-sinatra', git: 'https://github.com/OwnLocal/yard-sinatra.git'
end

group :test do
  gem 'database_cleaner'
  gem 'rack-test'
  gem 'rubocop'
end

group :production do
  gem 'puma'
end
