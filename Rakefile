# frozen_string_literal: true

namespace :cab do
  desc 'Осуществляет миграцию базы данных сервиса'
  task :migrate, [:to, :from] do |_task, args|
    require_relative 'config/app_init'

    Cab::Init.run!(only: %w[class_ext sequel])
    Cab.need 'tasks/migration'

    to = args[:to]
    from = args[:from]
    dir = "#{Cab.root}/db/migrations"
    db = Sequel::Model.db
    Cab::Tasks::Migration.new(db, to, from, dir).launch!
  end

  desc 'Переносит данные из старого сервиса'
  task :transfer do
    require_relative 'config/app_init'

    Cab::Init.run!(only: %w[class_ext oj sequel models])
    Cab.need 'tasks/transfer'

    Cab::Tasks::Transfer.launch!
  end
end
