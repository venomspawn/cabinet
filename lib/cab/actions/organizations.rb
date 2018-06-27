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
      def self.create(params)
        Create.new(params).create
      end

      require_relative 'organizations/create_vicarious_authority'

      # Создаёт запись документа, подтверждающего полномочия представителя,
      # создаёт запись связи между записями юридического лица, представителя и
      # созданного документа
      # @param [String] id
      #   идентификатор записи юридического лица
      # @param [Hash] params
      #   ассоциативный массив параметров действия
      def self.create_vicarious_authority(id, params)
        CreateVicariousAuthority.new(id, params).create
      end

      require_relative 'organizations/lookup'

      # Возвращает ассоциативный массив с информацией о юридических лицах
      # @param [Object] params
      #   объект с информацией о параметрах действия
      # @return [Hash]
      #   результирующий ассоциативный массив
      def self.lookup(params)
        Lookup.new(params).lookup
      end

      require_relative 'organizations/show'

      # Возвращает ассоциативный массив с информацией о юридическом лице
      # @param [Object] params
      #   объект с информацией о параметрах действия
      # @return [Hash]
      #   результирующий ассоциативный массив
      def self.show(params)
        Show.new(params).show
      end

      require_relative 'organizations/update'

      # Обновляет поля записи юридического лица и возвращает ассоциативный
      # массив с информацией об обновлённой записи
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
