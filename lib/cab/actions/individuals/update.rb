# frozen_string_literal: true

module Cab
  need 'actions/base/action'

  module Actions
    module Individuals
      # Класс действий обновления полей записи физического лица
      class Update < Base::Action
        require_relative 'update/params_schema'

        # Инициализирует объект класса
        # @param [String] id
        #   идентификатор записи
        # @param [Object] params
        #   параметры действия
        # @raise [Oj::ParseError]
        #   если параметры действия являются строкой, но не являются
        #   JSON-строкой
        # @raise [JSON::Schema::ValidationError]
        #   если аргумент не является объектом требуемых типа и структуры
        def initialize(id, params)
          super(params)
          @id = id
        end

        # Обновляет поля записи физического лица и возвращает ассоциативный
        # массив с информацией об обновлённой записи
        # @return [Hash]
        #   результирующий ассоциативный массив
        def update
          record.update(individual_params)
          Individuals.show(id: id, extended: false)
        end

        private

        # Идентификатор записи
        # @return [String] id
        #   идентификатор записи
        attr_reader :id

        # Возвращает запись физического лица
        # @return [Cab::Models::Individual]
        #   запись физического лица
        # @raise [Sequel::NoMatchingRow]
        #   если запись физического лица не найдена
        def record
          Models::Individual.select(:id).with_pk!(id)
        end

        # Копирует значения из одного ассоциативного массива в другой согласно
        # ключам предоставленной схемы и возвращает ассоциативный массив,
        # в который скопированы значения
        # @param [Hash] src
        #   ассоциативный массив, из которого копируются значения
        # @param [Hash] dst
        #   ассоциативный массив, в который копируются значения
        # @param [Hash] map
        #   ассоциативный массив, являющийся схемой ключей и отображающий ключи
        #   ассоциативного массива, из которого копируются значения, в ключи
        #   ассоциативного массива, в который копируются значения
        # @return [Hash]
        #   ассоциативный массив, в который скопированы значения
        def copy_existing(src, dst, map)
          dst.tap { map.each { |s, d| dst[d] = src[s] if src.key?(s) } }
        end

        # Ассоциативный массив, отображающий названия ключей ассоциативного
        # массива параметров в названия ключей ассоциативного массива атрибутов
        # записи физического лица
        INDIVIDUAL_FIELDS = {
          snils:                :snils,
          inn:                  :inn,
          residential_address:  :residence_address,
          registration_address: :registration_address
        }.freeze

        # Возвращает ассоциативный массив полей записи физического лица
        # @return [Hash]
        #   результирующий ассоциативный массив
        def individual_params
          copy_existing(params, {}, INDIVIDUAL_FIELDS)
        end
      end
    end
  end
end
