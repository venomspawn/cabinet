# frozen_string_literal: true

module Cab
  need 'settings/configurable'

  # Пространство имён классов, предоставляющих функционал нечёткого поиска
  module Lookup
    # Класс, предоставляющий функционал нечёткого поиска по полям записей
    # физических лиц
    class Fuzzy
      extend Settings::Configurable

      settings_names :first_name, :last_name, :middle_name, :birth_place

      # Ассоциативный массив, преобразующий названия параметров поиска в
      # названия полей записей физических лиц
      SEARCH_KEYS = {
        first_name:  :name,
        middle_name: :middle_name,
        last_name:   :surname,
        birth_place: :birth_place
      }.freeze

      # Названия параметров поиска, по которым производится нечёткий поиск
      FUZZY_KEYS = SEARCH_KEYS.keys.freeze

      # Инициализирует экземпляр класса
      # @param [Hash{Symbol => String}] params
      #   ассоциативный массив с параметрами поиска
      def initialize(params)
        @params = params.select { |k, v| FUZZY_KEYS.include?(k) && v.present? }
      end

      # Возвращает, отсутствуют ли параметры нечёткого поиска
      # @return [Boolean]
      #   отсутствуют ли параметры нечёткого поиска
      def empty_params?
        params.empty?
      end

      # Возвращает запрос Sequel на извлечение записей с помощью нечёткого
      # поиска
      # @param [Sequel::Dataset] source
      #   исходный запрос Sequel
      # @return [Sequel::Dataset]
      #   результирующий запрос Sequel
      def dataset(source)
        fuzzy_percents_dataset(source).order_by(total_distance.asc)
      end

      private

      # Ассоциативный массив с параметрами поиска
      # @return [Hash{Symbol => String}]
      #   ассоциативный массив с параметрами поиска
      attr_reader :params

      # Возвращает значение параметра поиска `birth_date`
      # @return [String]
      #   значение параметра поиска `birth_date`
      def birth_date
        params[:birth_date]
      end

      # Возвращает, присутствует ли параметра поиска `birth_date`
      # @return [Boolean]
      #   присутствует ли параметра поиска `birth_date`
      def birth_date?
        params.key?(:birth_date)
      end

      # Полное название поля `birthday` таблицы `individuals`
      BIRTHDAY = :birthday.qualify(:individuals)

      # Возвращает запрос Sequel, полученный из предоставленного добавлением
      # условий на похожесть значений полей и значений параметров
      # @param [Sequel::Dataset] source
      #   исходный запрос Sequel
      # @return [Sequel::Dataset]
      #   результирующий запрос Sequel
      def fuzzy_percents_dataset(source)
        source = source.where(BIRTHDAY => birth_date) if birth_date?
        params.each_key.inject(source) do |memo, key|
          condition = percent_expression(key)
          memo.where(condition)
        end
      end

      # Шаблон выражения для проверки похожести значения поля
      PERCENT_EXPRESSION_TEMPLATE = '"individuals"."%s" %% \'%s\''

      # Возвращает выражение Sequel для проверки, что похожесть значения поля
      # и предоставленного значения выше порога
      # @param [Symbol] key
      #   название параметра поиска
      # @return [Sequel::SQL::Expression]
      #   результирующее выражение Sequel
      def percent_expression(key)
        field = SEARCH_KEYS[key]
        value = params[key]
        format(PERCENT_EXPRESSION_TEMPLATE, field, value).lit
      end

      # Возвращает выражение Sequel для вычисления общей похожести
      # @return [Sequel::SQL::Expression]
      #   результирующие выражение Sequel
      def total_distance
        params.each_key.map(&method(:similarity_distance)).inject(:+)
      end

      # Шаблон выражения для вычисления похожести значения поля и значения
      # параметра с учётом веса
      SIMILARITY_DISTANCE_TEMPLATE = '("individuals"."%s" <-> \'%s\') * %f'

      # Возвращает выражение Sequel для вычисления похожести значения поля и
      # значения параметра
      # @param [Symbol] key
      #   название параметра поиска
      # @return [Sequel::SQL::Expression]
      #   результирующее выражение Sequel
      def similarity_distance(key)
        field = SEARCH_KEYS[key]
        value = params[key]
        weight = Fuzzy.settings[key]
        format(SIMILARITY_DISTANCE_TEMPLATE, field, value, weight).lit
      end
    end
  end
end
