# frozen_string_literal: true

module Cab
  need 'actions/base/action'

  module Actions
    module Individuals
      # Класс действий извлечения информации о физических лицах
      class Show < Base::Action
        require_relative 'show/params_schema'

        # Возвращает ассоциативный массив с информацией о физическом лице
        # @return [Hash]
        #   результирующий ассоциативный массив
        def show
          values.tap do |result|
            result[:client_type] = :individual
            expand_json(result, :registration_address)
            expand_json(result, :residential_address)
            next unless extended?
            agreement = result.delete(:agreement)
            result[:consent_to_processing] = [content: agreement.to_s]
            result[:identity_documents] = identity_documents
          end
        end

        private

        # Возвращает значение параметра `id`
        # @return [String]
        #   значение параметра `id`
        def id
          params[:id]
        end

        # Названия полей записи физического лица, извлекаемых из базы данных
        FIELDS = [
          :id,
          :name.as(:first_name),
          :surname.as(:last_name),
          :middle_name,
          :birth_place,
          :to_char.sql_function(:birthday, 'DD.MM.YYYY').as(:birth_date),
          :sex,
          :citizenship,
          :inn,
          :snils,
          :registration_address.cast(:text),
          :residence_address.cast(:text).as(:residential_address)
        ].freeze

        # Названия полей записи физического лица, извлекаемых из базы данных
        # в случае, когда необходимо возвращать информацию о документах
        EXTENDED_FIELDS = [*FIELDS, :agreement].freeze

        # Возвращает ассоциативный массив полей записи физического лица
        # @return [Hash]
        #   результирующий ассоциативный массив
        # @raise [Sequel::NoMatchingRow]
        #   если запись физического лица не найдена
        def values
          fields = extended? ? EXTENDED_FIELDS : FIELDS
          Models::Individual
            .naked
            .select(*fields)
            .where(id: id)
            .first!
        end

        # Возвращает, нужно ли возвращать информацию о документах
        # @return [Boolean]
        #   нужно ли возвращать информацию о документах
        def extended?
          return false if params[:extended].is_a?(FalseClass)
          return false if params[:extended] == 'false'
          true
        end

        # Названия полей записи документа, удостоверяющего личность
        DOC_FIELDS = [
          :type,
          :number,
          :series,
          :issued_by,
          :to_char.sql_function(:issue_date, 'DD.MM.YYYY').as(:issue_date),
          :to_char.sql_function(:expiration_end, 'DD.MM.YYYY').as(:due_date),
          :content
        ]

        # Возвращает список с информацией о документах, удостоверяющих личность
        # @return [Array]
        #   результирующий список
        def identity_documents
          identity_documents_dataset.map do |hash|
            hash.tap do
              content = hash.delete(:content)
              hash[:files] = [content: content.to_s]
            end
          end
        end

        # Возвращает запрос Sequel на извлечение записей документов,
        # удостоверяющих личность
        # @return [Sequel::Dataset]
        #   результирующий запрос Sequel
        def identity_documents_dataset
          Models::IdentityDocument
            .naked
            .select(*DOC_FIELDS)
            .where(individual_id: id)
            .order_by(:type, :created_at)
            .distinct(:type)
        end

        # Заменяет значение по данному ключу ассоциативного массива структурой,
        # восстановленной из JSON-строки, которая была исходным значением
        # @param [Hash] hash
        #   ассоциативный массив
        # @param [Object] key
        #   ключ
        def expand_json(hash, key)
          hash[key] &&= Oj.load(hash[key])
        end
      end
    end
  end
end
