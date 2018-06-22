# frozen_string_literal: true

require 'securerandom'

module Cab
  need 'actions/base/action'

  module Actions
    module Entrepreneurs
      # Класс действий создания записей индивидуальных предпринимателей
      class Create < Base::Action
        require_relative 'create/params_schema'

        # Создаёт запись индивидуального предпринимателя и возвращает
        # ассоциативный массив с информацией о созданной записи
        # @return [Hash]
        #   результирующий ассоциативный массив
        def create
          load_spokesman
          Sequel::Model.db.transaction(savepoint: true) do
            individual = process_individual
            record = create_entrepreneur(individual)
            vicarious_authority = create_vicarious_authority
            create_entrepreneur_spokesman(record, vicarious_authority)
            values(record, individual)
          end
        end

        private

        # Возвращает запись представителя или `nil`, если запись
        # индивидуального предпринимателя создаётся без указания записи
        # представителя
        # @return [Cab::Models::Individual]
        #   запись представителя
        # @return [NilClass]
        #   если запись индивидуального предпринимателя создаётся без указания
        #   записи представителя
        attr_reader :spokesman

        # Загружает запись представителя, если запись индивидуального
        # предпринимателя создаётся с его указанием
        # @raise [Sequel::NoMatchingRow]
        #   если запись представителя не найдена
        def load_spokesman
          @spokesman = params[:spokesman]&.[](:id)
          @spokesman &&= Models::Individual.select(:id).with_pk!(@spokesman)
        end

        # Возвращает значение параметра `individual_id`
        # @return [Object]
        #   значение параметра `individual_id`
        def individual_id
          params[:individual_id]
        end

        # Извлекает и возвращает ассоциативный массив с информацией о
        # физическом лице с идентификатором записи, равным значению параметра
        # `individual_id`, если оно предоставлено. В противном случае создаёт
        # запись физического лица и возвращает ассоциативный массив с
        # информацией о физическом лице.
        # @return [Hash]
        #   результирующий ассоциативный массив
        def process_individual
          return Individuals.create(individual_params) if individual_id.nil?
          Individuals.show(id: individual_id)
        end

        # Названия параметров создания записи физического лица
        INDIVIDUAL_FIELDS = %i[
          first_name
          last_name
          middle_name
          birth_place
          birth_date
          sex
          citizenship
          snils
          inn
          registration_address
          identity_document
          consent_to_processing
        ]

        # Возвращает ассоциативный массив параметров создания записи
        # физического лица
        # @return [Hash]
        #   результирующий ассоциативный массив
        def individual_params
          params.slice(*INDIVIDUAL_FIELDS).tap do |hash|
            hash[:residential_address] = params[:registration_address]
          end
        end

        # Создаёт и возвращает запись индивидуального предпринимателя
        # @param [Hash] individual
        #   ассоциативный массив с информацией о физическом лице
        # @return [Cab::Models::Entrepreneur]
        #   созданная запись
        def create_entrepreneur(individual)
          Models::Entrepreneur.unrestrict_primary_key
          record_params = entrepreneur_params(individual)
          Models::Entrepreneur.create(record_params).tap do
            Models::Entrepreneur.restrict_primary_key
          end
        end

        # Возвращает ассоциативный массив параметров создания записи
        # индивидуального предпринимателя
        # @param [Hash] individual
        #   ассоциативный массив с информацией о физическом лице
        # @return [Hash]
        #   результирующий ассоциативный массив
        def entrepreneur_params(individual)
          {}.tap do |hash|
            hash[:id]              = SecureRandom.uuid
            hash[:commercial_name] = params[:entrepreneur][:commercial_name]
            hash[:ogrn]            = params[:entrepreneur][:ogrn]
            hash[:bank_details]    = params[:bank_details]
            hash[:actual_address]  = params[:actual_address]
            hash[:created_at]      = Time.now
            hash[:individual_id]   = individual[:id]
          end
        end

        # Создаёт и возвращает запись документа, подтверждающего полномочия
        # представителя, если запись физического лица создаётся с указанием его
        # записи. Возвращает `nil` в противном случае.
        # @return [Cab::Models::VicariousAuthority]
        #   запись документа, подтверждающего полномочия представителя
        # @return [NilClass]
        #   если запись физического лица создаётся без указания записи
        #   представителя
        def create_vicarious_authority
          return if spokesman.nil?
          document_params = vicarious_authority_params
          Models::VicariousAuthority.unrestrict_primary_key
          Models::VicariousAuthority.create(document_params).tap do
            Models::VicariousAuthority.restrict_primary_key
          end
        end

        # Список названий полей записи документа, подтверждающего полномочия
        # представителя, значения которых извлекаются из параметров действия
        VICARIOUS_AUTHORITY_FIELDS =
          %i[number series registry_number issued_by issue_date].freeze

        # Возвращает ассоциативный массив полей записи документа,
        # подтверждающего полномочия представителя
        # @return [Hash]
        #   результирующий ассоциативный массив
        def vicarious_authority_params
          param = params[:spokesman][:power_of_attorney]
          param.slice(*VICARIOUS_AUTHORITY_FIELDS).tap do |hash|
            hash[:id]              = SecureRandom.uuid
            hash[:name]            = param[:title]
            hash[:expiration_date] = param[:due_date]
            hash[:content]         = param[:files].first[:content]
            hash[:created_at]      = Time.now
          end
        end

        # Создаёт запись связи между записями индивидуального предпринимателя и
        # его представителя, если запись индивидуального предпринимателя
        # создаётся с указанием записи представителя
        # @param [Cab::Models::Entrepreneur] record
        #   запись индивидуального предпринимателя
        # @param [NilClass, Models::VicariousAuthority] vicarious_authority
        #   запись документа, подтверждающего полномочия представителя, или
        #   `nil`, если запись индивидуального предпринимателя создаётся без
        #   указания записи представителя
        def create_entrepreneur_spokesman(record, vicarious_authority)
          return if vicarious_authority.nil?
          link_params =
            entrepreneur_spokesman_params(record, vicarious_authority)
          Models::EntrepreneurSpokesman.unrestrict_primary_key
          Models::EntrepreneurSpokesman.create(link_params)
          Models::EntrepreneurSpokesman.restrict_primary_key
        end

        # Возвращает ассоциативный массив полей записи связи между записями
        # индивидуального предпринимателя и его представителя
        # @param [Cab::Models::Entrepreneur] record
        #   запись индивидуального предпринимателя
        # @param [Cab::Models::VicariousAuthority] vicarious_authority
        #   запись документа, подтверждающего полномочия представителя
        # @return [Hash]
        #   результирующий ассоциативный массив
        def entrepreneur_spokesman_params(record, vicarious_authority)
          {
            created_at:             Time.now,
            spokesman_id:           spokesman.id,
            entrepreneur_id:        record.id,
            vicarious_authority_id: vicarious_authority.id
          }
        end

        # Копирует атрибуты из одного объекта в другой и возвращает объект, в
        # который копируются атрибуты
        # @param [#[]=] destination
        #   объект, в который копируются атрибуты
        # @param [#[]] source
        #   объект, из которого копируются атрибуты
        # @param [Array] keys
        #   названия атрибутов
        # @return [Object]
        #   объект, из которого копируются атрибуты
        def copy_attributes(destination, source, *keys)
          destination.tap { keys.each { |k| destination[k] = source[k] } }
        end

        # Названия полей ассоциативного массива атрибутов записи физического
        # лица, копируемых в ассоциативный массив атрибутов записи
        # индивидуального предпринимателя
        INDIVIDUAL_VALUES_FIELDS = %i[
          first_name
          last_name
          middle_name
          birth_place
          birth_date
          sex
          citizenship
          inn
          snils
          registration_address
          consent_to_processing
        ]

        # Возвращает ассоциативный массив атрибутов записи индивидуального
        # предпринимателя
        # @param [Cab::Models::Entrepreneur] record
        #   запись индивидуального предпринимателя
        # @param [Hash] individual
        #   ассоциативный массив с информацией о физическом лице
        # @return [Hash]
        #   результирующий ассоциативный массив
        def values(record, individual)
          {}.tap do |hash|
            copy_attributes(hash, individual, *INDIVIDUAL_VALUES_FIELDS)
            copy_attributes(hash, params, :actual_address, :bank_details)

            hash[:client_type]        = 'entrepreneur'
            hash[:id]                 = record.id
            hash[:identity_documents] = [params[:identity_document]]
            hash[:entrepreneur] =
              copy_attributes({}, record, :commercial_name, :ogrn)
          end
        end
      end
    end
  end
end
