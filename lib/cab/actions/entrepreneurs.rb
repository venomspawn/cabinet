# frozen_string_literal: true

module Cab
  module Actions
    # Пространство классов действий над записями индивидуальных
    # предпринимателей
    module Entrepreneurs
      require_relative 'entrepreneurs/create'

      # Создаёт запись индивидуального предпринимателя и возвращает
      # ассоциативный массив с информацией о созданной записи
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

      require_relative 'entrepreneurs/create_vicarious_authority'

      # Создаёт запись документа, подтверждающего полномочия представителя,
      # создаёт запись связи между записями индивидуального предпринимателя,
      # представителя и созданного документа
      # @param [Object] params
      #   объект с информацией о параметрах действия
      # @param [NilClass, Hash{Symbol => Object}] rest
      #   ассоциативный массив дополнительных параметров действия или `nil`,
      #   если дополнительные параметры отсутствуют
      def self.create_vicarious_authority(params, rest = nil)
        CreateVicariousAuthority.new(params, rest).create
      end

      require_relative 'entrepreneurs/lookup'

      # Возвращает ассоциативный массив с информацией об индивидуальных
      # предпринимателях
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

      require_relative 'entrepreneurs/show'

      # Возвращает ассоциативный массив с информацией об индивидуальном
      # предпринимателе
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

      require_relative 'entrepreneurs/update'

      # Обновляет поля записи индивидуального предпринимателя
      # @param [Object] params
      #   объект с информацией о параметрах действия
      # @param [NilClass, Hash{Symbol => Object}] rest
      #   ассоциативный массив дополнительных параметров действия или `nil`,
      #   если дополнительные параметры отсутствуют
      def self.update(params, rest = nil)
        Update.new(params, rest).update
      end

      require_relative 'entrepreneurs/update_personal_info'

      # Обновляет персональные данные у записи индивидуального предпринимателя
      # и возвращает ассоциативный массив с информацией о документе,
      # удостоверяющем личность
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
