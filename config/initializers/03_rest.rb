# frozen_string_literal: true

# Настройка REST-контроллера

# Загрузка REST-контроллера
Cab.need 'api/rest/controller'
Cab.need 'api/rest/logger'
Cab.need 'api/rest/**/*'

# Конфигурация REST-контроллера
Cab::API::REST::Controller.configure do |settings|
  settings.set     :bind, ENV['CAB_BIND_HOST']
  settings.set     :port, ENV['CAB_PORT']

  settings.disable :show_exceptions
  settings.disable :dump_errors
  settings.enable  :raise_errors

  settings.use Cab::API::REST::Logger

  settings.enable  :static
  settings.set     :root, Cab.root
end

# Конфигурация REST-контроллера для продуктивного стенда
Cab::API::REST::Controller.configure :production do |settings|
  settings.set     :server, :puma
end
