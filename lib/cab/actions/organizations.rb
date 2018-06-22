# frozen_string_literal: true

module Cab
  module Actions
    # Пространство классов действий над записями юридических лиц
    module Organizations
      require_relative 'organizations/create'

      # Создаёт запись юридического лица и возвращает ассоциативный массив с
      # информацией о созданной записи
      # @param [Hash] params
      #   ассоциативный массив параметров действия
      # @return [Hash]
      #   результирующий ассоциативный массив
      def self.create(params)
        Create.new(params).create
      end

      require_relative 'organizations/lookup'

      # Возвращает ассоциативный массив с информацией о юридических лицах
      # @param [Hash] params
      #   ассоциативный массив параметров действия
      # @return [Hash]
      #   результирующий ассоциативный массив
      def self.lookup(params)
        Lookup.new(params).lookup
      end

      require_relative 'organizations/show'

      # Возвращает ассоциативный массив с информацией о юридическом лице
      # @param [Hash] params
      #   ассоциативный массив параметров действия
      # @return [Hash]
      #   результирующий ассоциативный массив
      def self.show(params)
        Show.new(params).show
      end
    end
  end
end
