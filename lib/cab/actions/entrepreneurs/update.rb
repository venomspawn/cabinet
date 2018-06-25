# frozen_string_literal: true

module Cab
  need 'actions/base/action'

  module Actions
    module Entrepreneurs
      # Класс действий обновления полей записей индивидуальных предпринимателей
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

        # Обновляет поля записи индивидуального предпринимателя и возвращает
        # ассоциативный массив с информацией об обновлённой записи
        # @return [Hash]
        #   результирующий ассоциативный массив
        def update
          Sequel::Model.db.transaction(savepoint: true) do
            record.update(entrepreneur_params)
            individual.update(individual_params)
          end
          Entrepreneurs.show(id: id, extended: false)
        end

        private

        # Идентификатор записи
        # @return [String] id
        #   идентификатор записи
        attr_reader :id

        # Возвращает запись индивидуального предпринимателя
        # @return [Cab::Models::Entrepreneur]
        #   запись индивидуального предпринимателя
        # @raise [Sequel::NoMatchingRow]
        #   если запись индвидуального предпринимателя не найдена
        def record
          @record ||=
            Models::Entrepreneur.select(:id, :individual_id).with_pk!(id)
        end

        # Возвращает запись физического лица
        # @return [Cab::Models::Individual]
        #   запись физического лица
        # @raise [Sequel::NoMatchingRow]
        #   если запись физического лица не найдена
        def individual
          Models::Individual.select(:id).with_pk!(record.individual_id)
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
          registration_address: :registration_address
        }.freeze

        # Возвращает ассоциативный массив параметров создания записи
        # физического лица
        # @return [Hash]
        #   результирующий ассоциативный массив
        def individual_params
          copy_existing(params, {}, INDIVIDUAL_FIELDS)
        end

        # Ассоциативный массив, отображающий названия ключей ассоциативного
        # массива параметров в названия ключей ассоциативного массива атрибутов
        # записи индивидуального предпринимателя
        ENTREPRENEUR_FIELDS = {
          actual_address: :actual_address,
          bank_details:   :bank_details
        }

        # Ассоциативный массив, отображающий названия ключей ассоциативного
        # массива, являющегося значением параметра `entrepreneur`, в названия
        # ключей ассоциативного массива атрибутов записи индивидуального
        # предпринимателя
        ENTREPRENEUR_BLOCK_FIELDS = {
          commercial_name: :commercial_name,
          ogrn:            :ogrn
        }

        # Возвращает ассоциативный массив параметров создания записи
        # индивидуального предпринимателя
        # @return [Hash]
        #   результирующий ассоциативный массив
        def entrepreneur_params
          {}.tap do |hash|
            copy_existing(params, hash, ENTREPRENEUR_FIELDS)
            entrepreneur_block = params[:entrepreneur] || next
            copy_existing(entrepreneur_block, hash, ENTREPRENEUR_BLOCK_FIELDS)
          end
        end
      end
    end
  end

end
