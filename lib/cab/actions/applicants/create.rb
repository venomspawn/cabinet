# frozen_string_literal: true

module Cab
  need 'actions/base/action'

  module Actions
    module Applicants
      # Класс действий создания записей заявителей
      class Create < Base::Action
        require_relative 'create/params_schema'

        # Создаёт запись заявителя и возвращает ассоциативный массив с
        # информацией о созданной записи
        # @return [Hash]
        #   результирующий ассоциативный массив
        def create
          creation_module.create(creation_params)
        end

        private

        # Возвращает название первого параметра
        # @return [Symbol]
        #   название первого параметра
        def type
          @type ||= params.first.first
        end

        # Возвращает значение первого параметра
        # @return [Hash]
        #   значение первого параметра
        def creation_params
          params.first.last
        end

        # Возвращает модуль, функции `create` которого делегируется создание
        # записи заявителя
        def creation_module
          return Individuals if type == :individual
          return Entrepreneurs if type == :entrepreneur
          Organizations
        end
      end
    end
  end
end
