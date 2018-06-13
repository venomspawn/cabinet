# frozen_string_literal: true

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
end
