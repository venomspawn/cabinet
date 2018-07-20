# frozen_string_literal: true

module Cab
  module Actions
    # Пространство классов действий над записями физических лиц
    module Individuals
      require_relative 'individuals/create'

      # Создаёт запись физического лица и возвращает ассоциативный массив с
      # информацией о созданной записи
      # @param [Object] params
      #   объект с информацией о параметрах действия
      # @param [NilClass, Hash{Symbol => Object}] rest
      #   ассоциативный массив дополнительных параметров действия или `nil`,
      #   если дополнительные параметры отсутствуют
      # @return [Hash]
      #   результирующий ассоциативный массив
      def self.create(params, rest = nil)
        Create.new(params, rest).create
      end

      require_relative 'individuals/create_vicarious_authority'

      # Создаёт запись документа, подтверждающего полномочия представителя,
      # создаёт запись связи между записями физического лица, представителя и
      # созданного документа
      # @param [Object] params
      #   объект с информацией о параметрах действия
      # @param [NilClass, Hash{Symbol => Object}] rest
      #   ассоциативный массив дополнительных параметров действия или `nil`,
      #   если дополнительные параметры отсутствуют
      def self.create_vicarious_authority(params, rest = nil)
        CreateVicariousAuthority.new(params, rest).create
      end

      require_relative 'individuals/lookup'

      # Возвращает ассоциативный массив с информацией о физических лицах
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

      require_relative 'individuals/show'

      # Возвращает ассоциативный массив с информацией о физическом лице
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

      require_relative 'individuals/update'

      # Обновляет поля записи физического лица
      # @param [Object] params
      #   объект с информацией о параметрах действия
      # @param [NilClass, Hash{Symbol => Object}] rest
      #   ассоциативный массив дополнительных параметров действия или `nil`,
      #   если дополнительные параметры отсутствуют
      def self.update(params, rest = nil)
        Update.new(params, rest).update
      end

      require_relative 'individuals/update_personal_info'

      # Обновляет персональные данные у записи физического лица и возвращает
      # ассоциативный массив с информацией о документе, удостоверяющем личность
      # @param [Object] params
      #   объект с информацией о параметрах действия
      # @param [NilClass, Hash{Symbol => Object}] rest
      #   ассоциативный массив дополнительных параметров действия или `nil`,
      #   если дополнительные параметры отсутствуют
      # @return [Hash]
      #   результирующий ассоциативный массив
      def self.update_personal_info(params, rest = nil)
        UpdatePersonalInfo.new(params, rest).update
      end
    end
  end
end
