# frozen_string_literal: true

require 'json-schema'

module Cab
  # Пространство имён для модулей классов действий
  module Actions
    # Пространство имён для базовых классов действий
    module Base
      # Базовый класс действия. Реализует проверку параметров действия согласно
      # схеме, которая по умолчанию извлекается из константы `PARAMS_SCHEMA` в
      # пространстве имён класса, наследующего от данного.
      class Action
        # Инициализирует объект класса
        # @param [Object] params
        #   параметры действия
        # @raise [Oj::ParseError]
        #   если параметры действия являются строкой, но не являются
        #   JSON-строкой
        # @raise [NameError]
        #   если не найдена константа `PARAMS_SCHEMA` в пространстве имён
        #   класса, наследующего от данного
        # @raise [JSON::Schema::ValidationError]
        #   если аргумент не является объектом требуемых типа и структуры
        def initialize(params)
          @params = sanitize_params(params)
          JSON::Validator.validate!(params_schema, @params, parse_data: false)
        end

        private

        # Параметры действия
        # @return [Object]
        #   параметры действия
        attr_reader :params

        # Возвращает параметры действия в исправленном виде
        # @param [Object] params
        #   исходные параметры действия
        # @return [Object]
        #   параметры действия в исправленном виде
        # @raise [Oj::ParseError]
        #   если исходные параметры являются строкой, но не являются
        #   JSON-строкой
        def sanitize_params(params)
          return params.deep_symbolize_keys if params.is_a?(Hash)
          return Oj.load(params)            if params.is_a?(String)
          params
        end

        # Возвращает схему, по которой проверяется объект параметров
        # @return [Object]
        #   схема, по которой проверяет объект параметров
        # @raise [NameError]
        #   если не найдена константа `PARAMS_SCHEMA` в пространстве имён
        #   класса, наследующего от данного
        def params_schema
          self.class.const_get(:PARAMS_SCHEMA)
        end
      end
    end
  end
end
