# frozen_string_literal: true

module Cab
  module Actions
    # Пространство классов действий над записями индивидуальных
    # предпринимателей
    module Entrepreneurs
      require_relative 'entrepreneurs/show'

      # Возвращает ассоциативный массив с информацией об индивидуальном
      # предпринимателе
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
