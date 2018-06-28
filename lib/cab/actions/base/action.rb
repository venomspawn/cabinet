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

        # Возвращает ассоциативный массив, построенный на основе значений
        # параметров согласно предоставленной схеме
        # @param [Hash] map
        #   ассоциативный массив со схемой, ключами которого являются названия
        #   ключей результирующего ассоциативного массива, а значениями —
        #   названия параметров, списки с названиями ключей, объекты с методом
        #   `call` или иные объекты, по которым извлекаются значения
        # @return [Hash]
        #   результирующий ассоциативный массив
        def extract_params(map)
          map.each_with_object({}) do |(destination, source), memo|
            allowed, value = extract_param_value(source)
            memo[destination] = value if allowed
          end
        end

        # Возвращает список из двух элементов, значение которых вычисляется в
        # зависимости от типа аргумента.
        #
        # 1. Если аргумент имеет тип `Symbol`, то первый элемент означает, есть
        #    ли параметр с таким названием, а второй элемент является значением
        #    этого параметра.
        # 2. Если аргумент имеет тип `Array`, то первый элемент означает, есть
        #    ли значение по этому пути, а второй элемент является значением по
        #    пути.
        # 3. Если аргумент имеет метод `call`, то первый элемент равен булевому
        #    значению `true`, а второй является результатом вызова этого
        #    метода.
        # 4. Если ни одно из условий выше не выполнено, то первый элемент равен
        #    булевому значению `true`, а второй равен аргументу.
        #
        # @param [Object] source
        #   аргумент
        # @return [Array<(Boolean, Object)>]
        #   результирующий список
        def extract_param_value(source)
          return [params.key?(source), params[source]] if source.is_a?(Symbol)
          return extract_path_value(source) if source.is_a?(Array)
          return [true, source.call] if source.respond_to?(:call)
          [true, source]
        end

        # Извлекает значение из структуры параметров по предоставленному пути.
        # Предполагается, что структура параметров содержит только вложенные
        # объекты типа `Hash`. Возвращает список из двух элементов, где первый
        # элемент означает, есть ли значение по предоставленному пути, а второй
        # является значение по пути.
        # @param [Array] path
        #   путь
        # @return [Array<(Boolean, Object)>]
        #   результирующий список
        def extract_path_value(path)
          value = path.inject(params) do |memo, key|
            memo.key?(key) ? memo[key] : (return [false, nil])
          end
          [true, value]
        end

        # Убирает ограничение на присваивание значения первичного ключа модели,
        # создаёт запись модели, после чего возвращает ограничние на
        # присваивание значения первичного ключа модели. Возвращает созданную
        # запись.
        # @param [String, Symbol] model_name
        #   название модели в пространстве имён `Cab::Models`
        # @param [Hash] creation_params
        #   ассоциативный массив со значениями полей записи модели
        # @return [Object]
        #   созданная запись
        def create_unrestricted(model_name, creation_params)
          model = Models.const_get(model_name)
          model.unrestrict_primary_key
          model.create(creation_params).tap { model.restrict_primary_key }
        end
      end
    end
  end
end
