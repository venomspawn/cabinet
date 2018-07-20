# frozen_string_literal: true

module Cab
  module Actions
    # Пространство классов действий над записями документов, удостоверяющих
    # личность
    module Documents
      require_relative 'documents/update'

      # Обновляет содержимое файла документа, удостоверяющего личность
      # @param [Object] params
      #   объект с информацией о параметрах действия
      # @param [NilClass, Hash{Symbol => Object}] rest
      #   ассоциативный массив дополнительных параметров действия или `nil`,
      #   если дополнительные параметры отсутствуют
      def self.update(params, rest = nil)
        Update.new(params, rest).update
      end
    end
  end
end
