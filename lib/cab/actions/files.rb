# frozen_string_literal: true

module Cab
  module Actions
    # Пространство имён классов действий, оперирующих файлами
    module Files
      require_relative 'files/create'

      # Создаёт запись файла с предоставленным содержимым и возвращает
      # ассоциативный массив с информацией о записи
      # @param [#read, #to_s] content
      #   содержимое, которое может быть представлено потоком или извлечено с
      #   помощью `#to_s`
      # @return [Hash]
      #   результирующий ассоциативный массив
      def self.create(content)
        Create.new(content).create
      end

      require_relative 'files/show'

      # Возвращает содержимое файла
      # @param [Object] params
      #   параметры действия
      # @return [String]
      #   содержимое файла
      # @raise [Sequel::NoMatchingRow]
      #   если запись файла не найдена по предоставленному идентификатору
      def self.show(params)
        Show.new(params).show
      end

      require_relative 'files/update'

      # Обновляет содержимое файла
      # @param [Object] params
      #   параметры действия
      # @raise [Sequel::NoMatchingRow]
      #   если запись файла не найдена по предоставленному идентификатору
      def self.update(params)
        Update.new(params).update
      end
    end
  end
end
