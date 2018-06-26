# frozen_string_literal: true

module Cab
  need 'actions/base/action'

  module Actions
    module Applicants
      # Класс действий обновления персональных данных в записях заявителей
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

        # Обновляет персональные данные у записи заявителя и возвращает
        # ассоциативный массив с информацией об обновлённой записи
        # @return [Hash]
        #   результирующий ассоциативный массив
        def update
          update_module.update_personal_info(id, update_params)
        end

        private

        # Идентификатор записи
        # @return [String] id
        #   идентификатор записи
        attr_reader :id

        # Возвращает название первого параметра
        # @return [Symbol]
        #   название первого параметра
        def type
          @type ||= params.first.first
        end

        # Возвращает значение первого параметра
        # @return [Hash]
        #   значение первого параметра
        def update_params
          params.first.last
        end

        # Возвращает модуль, функции `update_personal_info` которого
        # делегируется создание записи заявителя
        def update_module
          type == :individual ? Individuals : Entrepreneurs
        end
      end
    end
  end
end
