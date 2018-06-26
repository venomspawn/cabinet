# frozen_string_literal: true

module Cab
  need 'actions/base/action'

  module Actions
    module Documents
      # Класс действий обновления содержимого файла документа, удостоверяющего
      # личность
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

        # Обновляет содержимое файла документа, удостоверяющего личность, и
        # возвращает список с информацией об обновлённом содержимом
        # @return [Hash]
        #   результирующий ассоциативный массив
        def update
          record.update(content: content)
          params
        end

        private

        # Идентификатор записи
        # @return [String] id
        #   идентификатор записи
        attr_reader :id

        # Возвращает запись документа, удостоверяющего личность
        # @return [Cab::Models::IdentityDocument]
        #   запись документа, удостоверяющего личность
        # @raise [Sequel::NoMatchingRow]
        #   если запись документа, удостоверяющего личность, не найдена
        def record
          Models::IdentityDocument.select(:id).with_pk!(id)
        end

        # Возвращает новое содержимое документа, удостоверяющего личность
        # @return [String]
        #   новое содержимое документа, удостоверяющего личность
        def content
          params.first[:content]
        end
      end
    end
  end
end
