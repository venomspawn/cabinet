# frozen_string_literal: true

# Настройка Sequel

require 'sequel'
require 'erb'
require 'yaml'

# Подключение расширений Sequel:
# 1) поддержка миграций;
Sequel.extension :migration
# 2) расширения базовых классов
Sequel.extension :core_extensions

# Инициализация подключения к базе данных
# Загрузка настройки базы данных
erb = IO.read("#{Cab.root}/config/database.yml")
yaml = ERB.new(erb).result
options = YAML.safe_load(yaml, [], [], true)
# Подключение
db = Sequel.connect(options[Cab.env])
# Подключение поддержки перечислимых типов Postgres. Важно, что подключение
# расширения pg_enum идёт после подключения расширения Sequel migration.
db.extension :pg_enum
# Поддержка JSON
db.extension :pg_json

# Настройка моделей
# Установка базу данных для моделей. Через свойство Sequel::Model.db в
# дальнейшем можно обращаться к базе данных.
Sequel::Model.db = db
# Подключение поддержки генерации исключений
Sequel::Model.raise_on_save_failure = true
Sequel::Model.raise_on_typecast_failure = true
# Плагин, который обрезает пробелы в начале и конце строки при установке
# строкового поля
Sequel::Model.plugin :string_stripper

# Отключение, необходимое для использования Puma. Без отключения процессы Puma
# используют одно и то же подключение, определённое в родительском процессе,
# что приводит к странным ошибкам. После отключения Sequel автоматически
# подключается к базе данных индивидуально для каждого дочернего процесса.
db.disconnect

# Журнал событий
db.loggers << Cab.logger unless Cab.production?
# Установка того, на каком уровне журнала событий происходит отображение
# SQL-запросов
db.sql_log_level = Cab.production? ? :unknown : :debug
