# frozen_string_literal: true

module Cab
  need 'helpers/log'

  # Пространство имён классов объектов, обслуживающих Rake-задачи
  module Tasks
    # Класс объектов, запускающих миграции базы данных
    class Migration
      include Helpers::Log

      # Запускает миграцию
      # @param [Sequel::Database] db
      #   база данных
      # @param [Integer] to
      #   номер миграции, к которому необходимо привести базу данных. Если
      #   равен `nil`, то база данных приводится к последнему номеру.
      # @param [Integer] from
      #   номер миграции, от которого будут применяться миграции к базе данных.
      #   Если равен `nil`, то в качестве значения берётся текущий номер
      #   миграции базы данных.
      # @param [String] dir
      #   путь к директории, где будут искаться миграции
      def self.launch!(db, to, from, dir)
        new(db, to, from, dir).launch!
      end

      # База данных
      # @return [Sequel::Database]
      #   база данных
      attr_reader :db

      # Номер миграции, к которому необходимо привести базу данных. Если равен
      # nil, то база данных приводится к последнему номеру.
      # @return [Integer]
      #   номер миграции
      attr_reader :to

      # Номер миграции, от которого будут применяться миграции к базе данных.
      # Если равен nil, то в качестве значения берётся текущий номер миграции
      # базы данных.
      # @return [Integer]
      #   номер миграции
      attr_reader :from

      # Путь к директории, где будут искаться миграции
      # @return [String]
      #   путь к директории
      attr_reader :dir

      # Инициализирует объект
      # @param [Sequel::Database] db
      #   база данных
      # @param [Integer] to
      #   номер миграции, к которому необходимо привести базу данных. Если
      #   равен nil, то база данных приводится к последнему номеру.
      # @param [Integer] from
      #   номер миграции, от которого будут применяться миграции к базе данных.
      #   Если равен nil, то в качестве значения берётся текущий номер миграции
      #   базы данных.
      # @param [String] dir
      #   путь к директории, где будут искаться миграции
      def initialize(db, to, from, dir)
        @db = db
        @to = to
        @from = from
        @dir = dir
      end

      # Запускает миграцию
      def launch!
        log_start
        Sequel::Migrator.run(db, dir, current: from&.to_i, target: to&.to_i)
        log_finish
      end

      # Создаёт записи в журнале событий о том, что начинается миграция базы
      # данных и какова эта миграция
      def log_start
        log_info { "Начинается миграция базы данных #{db.opts[:database]}" }

        log_info { <<~LOG }
          Исходная версия: #{from.nil? ? 'текущая' : from},
          целевая версия: #{to.nil? ? 'максимальная' : to}
        LOG
      end

      # Создаёт запись в журнале событий о том, что миграция базы данных
      # завершена
      def log_finish
        log_info { "Миграция базы данных #{db.opts[:database]} завершена" }
      end
    end
  end
end
