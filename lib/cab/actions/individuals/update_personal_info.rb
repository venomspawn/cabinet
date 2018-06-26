# frozen_string_literal: true

require 'securerandom'

module Cab
  need 'actions/base/action'

  module Actions
    module Individuals
      # Класс действий обновления персональных данных у записи физического лица
      class UpdatePersonalInfo < Base::Action
        require_relative 'update_personal_info/params_schema'

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

        # Обновляет персональные данные у записи физического лица и возвращает
        # ассоциативный массив с информацией об обновлённой записи
        # @return [Hash]
        #   результирующий ассоциативный массив
        def update
          Sequel::Model.db.transaction(savepoint: true) do
            record.update(individual_params)
            create_identity_document
          end
          Individuals.show(id: id)
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
          @record ||= Models::Individual.select(:id).with_pk!(id)
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
          first_name:  :name,
          last_name:   :surname,
          middle_name: :middle_name,
          birth_place: :birth_place,
          birth_date:  :birthday,
          sex:         :sex,
          citizenship: :citizenship
        }.freeze

        # Возвращает ассоциативный массив полей записи физического лица
        # @return [Hash]
        #   результирующий ассоциативный массив
        def individual_params
          copy_existing(params, {}, INDIVIDUAL_FIELDS)
        end

        # Создаёт запись документа, удостоверяющего личность физического лица
        def create_identity_document
          Models::IdentityDocument.unrestrict_primary_key
          Models::IdentityDocument.create(identity_document_params)
          Models::IdentityDocument.restrict_primary_key
        end

        # Список названий полей записи документа, удостоверяющего личность,
        # значения которых извлекаются из параметров действия
        IDENTITY_DOCUMENT_FIELDS =
          %i[type number series issued_by issue_date].freeze

        # Возвращает ассоциативный массив полей записи документа,
        # удостоверяющего личность
        # @return [Hash]
        #   результирующий ассоциативный массив
        def identity_document_params
          param = params[:identity_document]
          param.slice(*IDENTITY_DOCUMENT_FIELDS).tap do |hash|
            hash[:id]             = SecureRandom.uuid
            hash[:expiration_end] = param[:due_date]
            hash[:content]        = param[:files].first[:content]
            hash[:created_at]     = Time.now
            hash[:individual_id]  = record.id
          end
        end
      end
    end
  end
end
