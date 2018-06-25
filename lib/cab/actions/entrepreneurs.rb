# frozen_string_literal: true

module Cab
  module Actions
    # Пространство классов действий над записями индивидуальных
    # предпринимателей
    module Entrepreneurs
      require_relative 'entrepreneurs/create'

      # Создаёт запись индивидуального предпринимателя и возвращает
      # ассоциативный массив с информацией о созданной записи
      # @param [Hash] params
      #   ассоциативный массив параметров действия
      # @return [Hash]
      #   результирующий ассоциативный массив
      def self.create(params)
        Create.new(params).create
      end

      require_relative 'entrepreneurs/lookup'

      # Возвращает ассоциативный массив с информацией об индивидуальных
      # предпринимателях
      # @param [Hash] params
      #   ассоциативный массив параметров действия
      # @return [Hash]
      #   результирующий ассоциативный массив
      def self.lookup(params)
        Lookup.new(params).lookup
      end

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

      require_relative 'entrepreneurs/update'

      # Обновляет поля записи индивидуального предпринимателя и возвращает
      # ассоциативный массив с информацией об обновлённой записи
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
