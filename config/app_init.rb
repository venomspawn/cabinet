# frozen_string_literal: true

# Общая инициализация

require 'logger'
require 'dotenv'

# Корневая директория
root = File.absolute_path("#{__dir__}/..")

# Загрузка переменных окружения из .env файла
Dotenv.load(File.absolute_path("#{root}/.env.#{ENV['RACK_ENV']}"))

STDOUT.sync = true

logger = Logger.new(STDOUT)
logger.level = ENV['CAB_LOG_LEVEL'] || Logger::DEBUG
logger.progname = $PROGRAM_NAME
logger.formatter = proc do |severity, time, progname, message|
  "[#{progname}] [#{time.strftime('%F %T')}] #{severity.upcase}: #{message}\n"
end

app_name = 'cab'
# Загрузка корневого модуля
require "#{root}/lib/#{app_name}"

# Настройка системы иницализации
Cab::Init.configure do |settings|
  settings.set :initializers, "#{__dir__}/initializers"
  settings.set :root, root
  settings.set :logger, logger
end
