# frozen_string_literal: true

module Cab
  need 'actions/base/action'

  module Actions
    module Organizations
      # Класс действий обновления полей записей юридических лиц
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

        # Обновляет поля записи юридического лица и возвращает ассоциативный
        # массив с информацией об обновлённой записи
        # @return [Hash]
        #   результирующий ассоциативный массив
        # @raise [Sequel::NoMatchingRow]
        #   если запись юридического лица не найдена
        def update
          record.update(organization_params)
          Organizations.show(id: id)
        end

        private

        # Идентификатор записи
        # @return [String] id
        #   идентификатор записи
        attr_reader :id

        # Возвращает запись юридического лица
        # @return [Cab::Models::Organization]
        #   запись юридического лица
        # @raise [Sequel::NoMatchingRow]
        #   если запись юридического лица не найдена
        def record
          Models::Organization.select(:id).with_pk!(id)
        end

        # Список названий полей записи юридического лица, значения которых
        # извлекаются из параметров действия
        ORGANIZATION_FIELDS = %i[
          full_name
          chief_name
          chief_surname
          chief_middle_name
          registration_date
          inn
          kpp
          ogrn
          legal_address
          actual_address
          bank_details
        ].freeze

        # Возвращает ассоциативный массив полей записи юридического лица
        # @return [Hash]
        #   результирующий ассоциативный массив
        def organization_params
          params.slice(*ORGANIZATION_FIELDS).tap do |hash|
            hash[:short_name] = params[:sokr_name] if params.key?(:sokr_name)
          end
        end
      end
    end
  end
end
