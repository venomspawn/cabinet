# frozen_string_literal: true

module Cab
  module Actions
    # Пространство классов действий над записями заявителей
    module Applicants
      require_relative 'applicants/create'

      # Создаёт запись заявителя и возвращает ассоциативный массив с
      # информацией о созданной записи
      # @param [Hash] params
      #   ассоциативный массив параметров действия
      # @return [Hash]
      #   результирующий ассоциативный массив
      def self.create(params)
        Create.new(params).create
      end

      require_relative 'applicants/lookup'

      # Возвращает ассоциативный массив с информацией о заявителях
      # @param [Hash] params
      #   ассоциативный массив параметров действия
      # @return [Hash]
      #   результирующий ассоциативный массив
      def self.lookup(params)
        Lookup.new(params).lookup
      end

      require_relative 'applicants/show'

      # Возвращает ассоциативный массив с информацией о заявителе
      # @param [Hash] params
      #   ассоциативный массив параметров действия
      # @return [Hash]
      #   результирующий ассоциативный массив
      def self.show(params)
        Show.new(params).show
      end

      require_relative 'applicants/update'

      # Обновляет поля записи заявителя и возвращает ассоциативный массив с
      # информацией об обновлённой записи
      # @param [String] id
      #   идентификатор записи
      # @param [Object] params
      #   объект с информацией о параметрах действия
      # @return [Hash]
      #   результирующий ассоциативный массив
      def self.update(id, params)
        Update.new(id, params).update
      end
    end
  end
end
