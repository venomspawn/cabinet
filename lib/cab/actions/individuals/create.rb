# frozen_string_literal: true

require 'securerandom'

module Cab
  need 'actions/base/action'

  module Actions
    module Individuals
      # Класс действий создания записи физического лица
      class Create < Base::Action
        require_relative 'create/params_schema'

        # Создаёт запись физического лица и возвращает ассоциативный массив с
        # информацией о созданной записи
        # @return [Hash]
        #   результирующий ассоциативный массив
        def create
          load_spokesman
          Sequel::Model.db.transaction(savepoint: true) do
            record = create_individual
            create_identity_document(record)
            vicarious_authority = create_vicarious_authority
            create_individual_spokesman(record, vicarious_authority)
            values(record)
          end
        end

        private

        # Возвращает запись представителя или `nil`, если запись физического
        # лица создаётся без указания записи представителя
        # @return [Cab::Models::Individual]
        #   запись представителя
        # @return [NilClass]
        #   если запись физического лица создаётся без указания записи
        #   представителя
        attr_reader :spokesman

        # Загружает запись представителя, если запись физического лица
        # создаётся с его указанием
        # @raise [Sequel::NoMatchingRow]
        #   если запись представителя не найдена
        def load_spokesman
          @spokesman = params[:spokesman]&.[](:id)
          @spokesman &&= Models::Individual.select(:id).with_pk!(@spokesman)
        end

        # Создаёт и возвращает запись физического лица
        # @return [Cab::Models::Individual]
        #   созданная запись физического лица
        def create_individual
          Models::Individual.unrestrict_primary_key
          Models::Individual.create(individual_params).tap do
            Models::Individual.restrict_primary_key
          end
        end

        # Список названий полей записи физического лица, значения которых
        # извлекаются из параметров действия
        INDIVIDUAL_FIELDS = %i[
          middle_name
          birth_place
          sex
          citizenship
          snils
          inn
          registration_address
        ].freeze

        # Возвращает ассоциативный массив полей записи физического лица
        # @return [Hash]
        #   результирующий ассоциативный массив
        def individual_params
          params.slice(*INDIVIDUAL_FIELDS).tap do |hash|
            hash[:id]                = SecureRandom.uuid
            hash[:name]              = params[:first_name]
            hash[:surname]           = params[:last_name]
            hash[:birthday]          = params[:birth_date]
            hash[:residence_address] = params[:residential_address]
            hash[:created_at]        = Time.now

            hash[:agreement] = params[:consent_to_processing].first[:content]
          end
        end

        # Создаёт запись документа, удостоверяющего личность физического лица
        # @param [Cab::Models::Individual] record
        #   запись физического лица
        def create_identity_document(record)
          document_params = identity_document_params(record)
          Models::IdentityDocument.unrestrict_primary_key
          Models::IdentityDocument.create(document_params)
          Models::IdentityDocument.restrict_primary_key
        end

        # Список названий полей записи документа, удостоверяющего личность,
        # значения которых извлекаются из параметров действия
        IDENTITY_DOCUMENT_FIELDS =
          %i[type number series issued_by issue_date].freeze

        # Возвращает ассоциативный массив полей записи документа,
        # удостоверяющего личность
        # @param [Cab::Models::Individual] record
        #   запись физического лица
        # @return [Hash]
        #   результирующий ассоциативный массив
        def identity_document_params(record)
          param = params[:identity_document]
          param.slice(*IDENTITY_DOCUMENT_FIELDS).tap do |hash|
            hash[:id]             = SecureRandom.uuid
            hash[:expiration_end] = param[:due_date]
            hash[:content]        = param[:files].first[:content]
            hash[:created_at]     = Time.now
            hash[:individual_id]  = record.id
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

        # Создаёт запись связи между записями физического лица и его
        # представителя, если запись физического лица создаётся с указанием
        # записи представителя
        # @param [Cab::Models::Individual] record
        #   запись физического лица
        # @param [NilClass, Models::VicariousAuthority] vicarious_authority
        #   запись документа, подтверждающего полномочия представителя, или
        #   `nil`, если запись физического лица создаётся без указания записи
        #   представителя
        def create_individual_spokesman(record, vicarious_authority)
          return if vicarious_authority.nil?
          link_params =
            individual_spokesman_params(record, vicarious_authority)
          Models::IndividualSpokesman.unrestrict_primary_key
          Models::IndividualSpokesman.create(link_params)
          Models::IndividualSpokesman.restrict_primary_key
        end

        # Возвращает ассоциативный массив полей записи связи между записями
        # физического лица и его представителя
        # @param [Cab::Models::Individual] record
        #   запись физического лица
        # @param [Cab::Models::VicariousAuthority] vicarious_authority
        #   запись документа, подтверждающего полномочия представителя
        # @return [Hash]
        #   результирующий ассоциативный массив
        def individual_spokesman_params(record, vicarious_authority)
          {
            created_at:             Time.now,
            spokesman_id:           spokesman.id,
            individual_id:          record.id,
            vicarious_authority_id: vicarious_authority.id
          }
        end

        # Названия полей ассоциативного массива атрибутов записи физического
        # лица, копируемых из параметров действия
        VALUES_FIELDS = %i[
          first_name
          last_name
          birth_place
          birth_date
          sex
          citizenship
          residential_address
          consent_to_processing
        ]

        # Возвращает ассоциативный массив атрибутов записи физического лица
        # @param [Cab::Models::Individual] record
        #   запись физического лица
        # @return [Hash]
        #   результирующий ассоциативный массив
        def values(record)
          params.slice(*VALUES_FIELDS).tap do |hash|
            hash[:client_type]          = 'individual'
            hash[:id]                   = record.id
            hash[:middle_name]          = params[:middle_name]
            hash[:inn]                  = params[:inn]
            hash[:snils]                = params[:snils]
            hash[:registration_address] = params[:registration_address]
            hash[:identity_documents]   = [params[:identity_document]]
          end
        end
      end
    end
  end
end
