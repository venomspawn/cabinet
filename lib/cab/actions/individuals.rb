# frozen_string_literal: true

module Cab
  module Actions
    # Пространство классов действий над записями физических лиц
    module Individuals
      require_relative 'individuals/lookup'

      # Возвращает ассоциативный массив с информацией о физических лицах
      # @param [Hash] params
      #   ассоциативный массив параметров действия
      # @return [Hash]
      #   результирующий ассоциативный массив
      def self.lookup(params)
        Lookup.new(params).lookup
      end

      require_relative 'individuals/show'

      # Возвращает ассоциативный массив с информацией о физическом лице
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
