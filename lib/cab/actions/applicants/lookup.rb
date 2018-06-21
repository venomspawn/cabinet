# frozen_string_literal: true

module Cab
  need 'actions/base/action'

  module Actions
    module Applicants
      class Lookup < Base::Action
        require_relative 'lookup/params_schema'

        # Возвращает ассоциативный массив с информацией о заявителях
        # @return [Hash]
        #   результирующий ассоциативный массив
        def lookup
          lookup_module.lookup(lookup_params)
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
        def lookup_params
          params.first.last
        end

        # Возвращает модуль, функции `lookup`  которого делегируется поиск
        # заявителя
        def lookup_module
          return Individuals if type == :individual
          return Entrepreneurs if type == :entrepreneur
          Organizations
        end
      end
    end
  end
end
