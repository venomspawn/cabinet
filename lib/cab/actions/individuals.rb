# frozen_string_literal: true

module Cab
  module Actions
    # Пространство классов действий над записями физических лиц
    module Individuals
      require_relative 'individuals/create'

      # Создаёт запись физического лица и возвращает ассоциативный массив с
      # информацией о созданной записи
      # @param [Hash] params
      #   ассоциативный массив параметров действия
      # @return [Hash]
      #   результирующий ассоциативный массив
      def self.create(params)
        Create.new(params).create
      end

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

      require_relative 'individuals/update'

      # Обновляет поля записи физического лица и возвращает ассоциативный
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

      require_relative 'individuals/update_personal_info'

      # Обновляет персональные данные у записи физического лица и возвращает
      # ассоциативный массив с информацией об обновлённой записи
      # @param [String] id
      #   идентификатор записи
      # @param [Object] params
      #   объект с информацией о параметрах действия
      # @return [Hash]
      #   результирующий ассоциативный массив
      def self.update_personal_info(id, params)
        UpdatePersonalInfo.new(id, params).update
      end
    end
  end
end
