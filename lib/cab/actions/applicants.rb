# frozen_string_literal: true

module Cab
  module Actions
    # Пространство классов действий над записями заявителей
    module Applicants
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
    end
  end
end
