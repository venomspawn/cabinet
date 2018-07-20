# frozen_string_literal: true

module Cab
  module Actions
    # Пространство классов действий над записями юридических лиц
    module Organizations
      require_relative 'organizations/create'

      # Создаёт запись юридического лица и возвращает ассоциативный массив с
      # информацией о созданной записи
      # @param [Object] params
      #   объект с информацией о параметрах действия
      # @return [Hash]
      #   результирующий ассоциативный массив
      def self.create(params, rest = nil)
        Create.new(params, rest).create
      end

      require_relative 'organizations/create_vicarious_authority'

      # Создаёт запись документа, подтверждающего полномочия представителя,
      # создаёт запись связи между записями юридического лица, представителя и
      # созданного документа
      # @param [Object] params
      #   объект с информацией о параметрах действия
      # @param [NilClass, Hash{Symbol => Object}] rest
      #   ассоциативный массив дополнительных параметров действия или `nil`,
      #   если дополнительные параметры отсутствуют
      def self.create_vicarious_authority(params, rest = nil)
        CreateVicariousAuthority.new(params, rest).create
      end

      require_relative 'organizations/lookup'

      # Возвращает ассоциативный массив с информацией о юридических лицах
      # @param [Object] params
      #   объект с информацией о параметрах действия
      # @param [NilClass, Hash{Symbol => Object}] rest
      #   ассоциативный массив дополнительных параметров действия или `nil`,
      #   если дополнительные параметры отсутствуют
      # @return [Hash]
      #   результирующий ассоциативный массив
      def self.lookup(params, rest = nil)
        Lookup.new(params, rest).lookup
      end

      require_relative 'organizations/show'

      # Возвращает ассоциативный массив с информацией о юридическом лице
      # @param [Object] params
      #   объект с информацией о параметрах действия
      # @param [NilClass, Hash{Symbol => Object}] rest
      #   ассоциативный массив дополнительных параметров действия или `nil`,
      #   если дополнительные параметры отсутствуют
      # @return [Hash]
      #   результирующий ассоциативный массив
      def self.show(params, rest = nil)
        Show.new(params, rest).show
      end

      require_relative 'organizations/update'

      # Обновляет поля записи юридического лица
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
