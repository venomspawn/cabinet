# frozen_string_literal: true

require 'set'

require_relative 'cab/init'

# Корневое пространство имён для всех классов сервиса
module Cab
  # Возвращает полный путь к корневой директории сервиса
  # @return [#to_s]
  #   полный путь к корневой директории сервиса
  def self.root
    Init.settings.root
  end

  # Возвращает журнал событий
  # @return [Logger]
  #   журнал событий
  def self.logger
    Init.settings.logger
  end

  # Возвращает полный путь к директории исходных файлов сервиса
  # @return [#to_s]
  #   полный путь к директории исходных файлов сервиса
  def self.lib
    @lib ||= "#{__dir__}/#{name}"
  end

  # Возвращает название сервиса
  # @return [String]
  #   название сервиса
  def self.name
    @name ||= to_s.downcase
  end

  # Тип окружения для разработки
  DEVELOPMENT = 'development'

  # Тип окружения для тестирования
  TEST = 'test'

  # Тип окружения для продуктивного стенда
  PRODUCTION = 'production'

  # Множество типов окружений
  ENVIRONMENTS = [DEVELOPMENT, TEST, PRODUCTION].to_set

  # Возвращает значение переменной окружения `RACK_ENV` или строку
  # {DEVELOPMENT}, если значение переменной окружения `RACK_ENV` отсутствует
  # во множестве {ENVIRONMENTS}
  # @return [String]
  #   значение переменной окружения `RACK_ENV` или строка {DEVELOPMENT}, если
  #   значение переменной окружения `RACK_ENV` отсутствует во множестве
  #   {ENVIRONMENTS}
  def self.env
    value = ENV['RACK_ENV']
    ENVIRONMENTS.include?(value) ? value : DEVELOPMENT
  end

  # Возвращает, выставлено ли окружение для разработки
  # @return [Boolean]
  #   выставлено ли окружение для разработки
  def self.development?
    env == DEVELOPMENT
  end

  # Возвращает, выставлено ли окружение для тестирования
  # @return [Boolean]
  #   выставлено ли окружение для тестирования
  def self.test?
    env == TEST
  end

  # Возвращает, выставлено ли окружение для продуктивного стенда
  # @return [Boolean]
  #   выставлено ли окружение для продуктивного стенда
  def self.production?
    env == PRODUCTION
  end

  # Расширение файлов исходного кода
  RB_EXT = '.rb'

  # Загружает один или несколько файлов исходного кода согласно маске,
  # включающей в себя частичный путь от директории по пути {lib}. Добавляет в
  # конец маски строку `.rb`, если она отсутствует. Не создаёт исключений, если
  # по маске ничего не найдено.
  # @example
  #   need 'init' — загрузка файла `init.rb`, который находится в директории
  #   {lib}
  # @example
  #   need 'models/**/*' — загрузка всех файлов исходного кода, находящихся в
  #   директории по частичному пути `models` от директории {lib} или в её
  #   дочерних директориях
  # @param [#to_s] mask
  #   маска
  def self.need(mask)
    mask = mask.to_s
    mask = "#{mask}.rb" unless mask.end_with?(RB_EXT)
    Dir["#{lib}/#{mask}"].each do |filepath|
      begin
        require filepath
      rescue StandardError
        nil
      end
    end
  end
end
