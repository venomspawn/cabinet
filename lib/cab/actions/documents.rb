# frozen_string_literal: true

module Cab
  module Actions
    # Пространство классов действий над записями документов, удостоверяющих
    # личность
    module Documents
      require_relative 'documents/update'

      # Обновляет содержимое файла документа, удостоверяющего личность, и
      # возвращает список с информацией о документе
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
