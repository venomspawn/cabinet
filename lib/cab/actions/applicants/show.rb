# frozen_string_literal: true

module Cab
  need 'actions/base/action'

  module Actions
    module Applicants
      class Show < Base::Action
        require_relative 'show/params_schema'

        # Возвращает ассоциативный массив с информацией о заявителе
        # @return [Hash]
        #   результирующий ассоциативный массив
        def show
          individual || entrepreneur || organization
        end

        private

        # Возвращает ассоциативный массив с информацией о физическом лице или
        # `nil`, если запись физического лица не найдена
        # @return [Hash]
        #   результирующий ассоциативный массив
        # @return [NilClass]
        #   если запись физического лица не найдена
        def individual
          Individuals.show(params)
        rescue Sequel::NoMatchingRow
          nil
        end

        # Возвращает ассоциативный массив с информацией об индивидуальном
        # предпринимателе или `nil`, если запись индивидуального
        # предпринимателя не найдена
        # @return [Hash]
        #   результирующий ассоциативный массив
        # @return [NilClass]
        #   если запись индивидуального предпринимателя не найдена
        def entrepreneur
          Entrepreneurs.show(params)
        rescue Sequel::NoMatchingRow
          nil
        end

        # Возвращает ассоциативный массив с информацией о юридическом лице
        # @return [Hash]
        #   результирующий ассоциативный массив
        def organization
          Organizations.show(id: params[:id])
        end
      end
    end
  end
end
