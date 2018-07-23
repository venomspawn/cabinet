# frozen_string_literal: true

require_relative 'validator'

module Cab
  # Пространство имён для модулей классов действий
  module Actions
    # Пространство имён для базовых классов действий
    module Base
      # Базовый класс действия. Реализует проверку параметров действия согласно
      # схеме, которая по умолчанию извлекается из константы `PARAMS_SCHEMA` в
      # пространстве имён класса, наследующего от данного.
      class Action
        extend Validator

        # Инициализирует объект класса
        # @param [Object] params
        #   объект с информацией о параметрах действия, который может быть
        #   ассоциативным массивом, JSON-строкой или объектом, предоставляющим
        #   метод `#read`
        # @param [NilClass, Hash] rest
        #   ассоциативный массив дополнительных параметров действия или `nil`,
        #   если дополнительные параметры отсутствуют
        # @return [Hash{Symbol => Object}]
        #   результирующий ассоциативный массив параметров действия
        # @raise [Oj::ParseError, EncodingError]
        #   если предоставленный объект с информацией о параметрах действия
        #   является строкой, но не является корректной JSON-строкой
        # @raise [JSON::Schema::ValidationError]
        #   если результирующая структура не является ассоциативным массивом,
        #   соответствующим JSON-схеме
        def initialize(params, rest = nil)
          @params = process_params(params, rest)
        end

        private

        # Ассоциативный массив параметров действий
        # @return [Hash{Symbol => Object}]
        #   ассоциативный массив параметров действий
        attr_reader :params

        # Извлекает ассоциативный массив параметров действия из предоставленных
        # аргументов, проверяет его на соответствие JSON-схеме и возвращает его
        # @param [Object] params
        #   объект с информацией о параметрах действия, который может быть
        #   ассоциативным массивом, JSON-строкой или объектом, предоставляющим
        #   метод `#read`
        # @param [NilClass, Hash] rest
        #   ассоциативный массив дополнительных параметров действия или `nil`,
        #   если дополнительные параметры отсутствуют
        # @return [Hash{Symbol => Object}]
        #   результирующий ассоциативный массив параметров действия
        # @raise [Oj::ParseError, EncodingError]
        #   если предоставленный объект с информацией о параметрах действия
        #   является строкой, но не является корректной JSON-строкой
        # @raise [JSON::Schema::ValidationError]
        #   если результирующая структура не является ассоциативным массивом,
        #   соответствующим JSON-схеме
        def process_params(params, rest)
          return process_hash(params, rest) if params.is_a?(Hash)
          return process_json(params, rest) if params.is_a?(String)
          return process_read(params, rest) if params.respond_to?(:read)
          # Для генерации JSON::Schema::ValidationError
          validate!(params)
        end

        # Добавляет дополнительные параметры, если они даны, в предоставленный
        # ассоциативный массив, проверяет получившийся ассоциативный массив на
        # соответствие JSON-схеме и возвращает его
        # @param [Hash{Symbol => Object}] hash
        #   предоставленный ассоциативный массив
        # @param [NilClass, Hash] rest
        #   ассоциативный массив дополнительных параметров действия или `nil`,
        #   если дополнительные параметры отсутствуют
        # @return [Hash{Symbol => Object}]
        #   результирующий ассоциативный массив
        # @raise [JSON::Schema::ValidationError]
        #   если результирующий ассоциативный массив не соответствует
        #   JSON-схеме
        def process_hash(hash, rest)
          result = rest.nil? ? hash : hash.merge(rest)
          result.tap { validate!(stringify(result)) }
        end

        # Настройки восстановления структур данных из JSON-строк при помощи
        # `Oj` с ключами ассоциативных массивов типа `String`
        STRING_KEYS = { symbol_keys: false }.freeze

        # Выполняет следующие действия.
        #
        # 1.  Восстанавливает структуру из предоставленной JSON-строки.
        # 2.  Проверяет, что восстановленная структура является ассоциативным
        #     массивом.
        # 3.  Добавляет к восстановленному ассоциативному массиву
        #     дополнительные параметры, если такие предоставлены.
        # 4.  Проверяет полученный ассоциативный массив на соответствие
        #     JSON-схеме.
        # 5.  Возвращает проверенный ассоциативный массив.
        # @param [String] json
        #   предоставленная JSON-строка
        # @param [NilClass, Hash] rest
        #   ассоциативный массив дополнительных параметров действия или `nil`,
        #   если дополнительные параметры отсутствуют
        # @return [Hash{Symbol => Object}]
        #   восстановленный ассоциативный массив
        # @raise [Oj::ParseError, EncodingError]
        #   если во время восстановления произошла ошибка
        # @raise [JSON::Schema::ValidationError]
        #   если восстановленная структура не является ассоциативным массивом,
        #   соответствующим JSON-схеме
        def process_json(json, rest)
          # Восстановление с ключами типа String
          data = Oj.load(json, STRING_KEYS)
          # Для генерации JSON::Schema::ValidationError
          validate!(data) unless data.is_a?(Hash)
          data.update(stringify(rest)) unless rest.nil?
          validate!(data)
          # Восстановление с ключами типа Symbol
          data = Oj.load(json)
          rest.nil? ? data : data.update(rest)
        end

        # Считывает строку с помощью метода `#read` предоставленного объекта,
        # вызывая предварительно метод `#rewind`, если такой есть, и возвращает
        # результат метода {process_json} для считанной строки
        # @param [#read] stream
        #   предоставленный объект
        # @param [NilClass, Hash] rest
        #   ассоциативный массив дополнительных параметров действия или `nil`,
        #   если дополнительные параметры отсутствуют
        # @return [Hash{Symbol => Object}]
        #   восстановленный ассоциативный массив
        # @raise [Oj::ParseError, EncodingError]
        #   если во время восстановления произошла ошибка
        # @raise [JSON::Schema::ValidationError]
        #   если восстановленная структура не является ассоциативным массивом,
        #   соответствующим JSON-схеме
        def process_read(stream, rest)
          stream.rewind if stream.respond_to?(:rewind)
          process_json(stream.read.to_s, rest)
        end

        # Осуществляет проверку структуры на соответствие JSON-схеме.
        # Предполагает, что все ключи ассоциативных массивов и строки в
        # структуре приведены к типу `String` с помощью метода {stringify}.
        # @param [Object] data
        #   структура
        # @raise [JSON::Schema::ValidationError]
        #   если структура не соответствует JSON-схеме
        def validate!(data)
          self.class.validate!(data)
        end

        # Возвращает копию структуры, в которой все ключи ассоциативных
        # массивов и строки приведены к типу `String`
        # @param [Object] data
        #   структура
        # @return [Object] data
        #   приведённая копия структуры
        def stringify(data)
          self.class.stringify(data)
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
          model.create(creation_params)
        ensure
          model.restrict_primary_key
        end
      end
    end
  end
end
