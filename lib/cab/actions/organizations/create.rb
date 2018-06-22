# frozen_string_literal: true

require 'securerandom'

module Cab
  need 'actions/base/action'

  module Actions
    module Organizations
      # Класс действий создания записи юридического лица
      class Create < Base::Action
        require_relative 'create/params_schema'

        # Создаёт запись юридического лица и возвращает ассоциативный массив с
        # информацией о созданной записи
        # @return [Hash]
        #   результирующий ассоциативный массив
        def create
          load_spokesman
          Sequel::Model.db.transaction(savepoint: true) do
            record = create_organization
            vicarious_authority = create_vicarious_authority
            create_organization_spokesman(record, vicarious_authority)
            values(record)
          end
        end

        private

        # Возвращает запись представителя
        # @return [Cab::Models::Individual]
        #   запись представителя
        attr_reader :spokesman

        # Загружает запись представителя
        # @raise [Sequel::NoMatchingRow]
        #   если запись представителя не найдена
        def load_spokesman
          @spokesman =
            Models::Individual.select(:id).with_pk!(params[:spokesman][:id])
        end

        # Создаёт и возвращает запись юридического лица
        # @return [Cab::Models::Organization]
        #   созданная запись юридического лица
        def create_organization
          Models::Organization.unrestrict_primary_key
          Models::Organization.create(organization_params).tap do
            Models::Organization.restrict_primary_key
          end
        end

        # Список названий полей записи юридического лица, значения которых
        # извлекаются из параметров действия
        ORGANIZATION_FIELDS = %i[
          full_name
          chief_name
          chief_surname
          chief_middle_name
          registration_date
          inn
          kpp
          ogrn
          legal_address
          actual_address
          bank_details
        ].freeze

        # Возвращает ассоциативный массив полей записи юридического лица
        # @return [Hash]
        #   результирующий ассоциативный массив
        def organization_params
          params.slice(*ORGANIZATION_FIELDS).tap do |hash|
            hash[:id]         = SecureRandom.uuid
            hash[:short_name] = params[:sokr_name]
            hash[:created_at] = Time.now
          end
        end

        # Создаёт и возвращает запись документа, подтверждающего полномочия
        # представителя
        # @return [Cab::Models::VicariousAuthority]
        #   запись документа, подтверждающего полномочия представителя
        def create_vicarious_authority
          Models::VicariousAuthority.unrestrict_primary_key
          Models::VicariousAuthority.create(vicarious_authority_params).tap do
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

        # Создаёт запись связи между записями юридического лица и его
        # представителя
        # @param [Cab::Models::Organization] record
        #   запись юридического лица
        # @param [Cab::Models::VicariousAuthority] vicarious_authority
        #   запись документа, подтверждающего полномочия представителя
        def create_organization_spokesman(record, vicarious_authority)
          link_params =
            organization_spokesman_params(record, vicarious_authority)
          Models::OrganizationSpokesman.unrestrict_primary_key
          Models::OrganizationSpokesman.create(link_params)
          Models::OrganizationSpokesman.restrict_primary_key
        end

        # Возвращает ассоциативный массив полей записи связи между записями
        # юридического лица и его представителя
        # @param [Cab::Models::Organization] record
        #   запись юридического лица
        # @param [Cab::Models::VicariousAuthority] vicarious_authority
        #   запись документа, подтверждающего полномочия представителя
        # @return [Hash]
        #   результирующий ассоциативный массив
        def organization_spokesman_params(record, vicarious_authority)
          {
            created_at:             Time.now,
            spokesman_id:           spokesman.id,
            organization_id:        record.id,
            vicarious_authority_id: vicarious_authority.id
          }
        end

        # Названия полей ассоциативного массива атрибутов записи юридического
        # лица, копируемых из параметров действия
        VALUES_FIELDS = %i[
          full_name
          registration_date
          inn
          kpp
          ogrn
          legal_address
        ]

        # Возвращает ассоциативный массив атрибутов записи юридического лица
        # @param [Cab::Models::Organization] record
        #   запись юридического лица
        # @return [Hash]
        #   результирующий ассоциативный массив
        def values(record)
          params.slice(*VALUES_FIELDS).tap do |hash|
            hash[:client_type]    = 'organization'
            hash[:id]             = record.id
            hash[:sokr_name]      = params[:short_name]
            hash[:director]       = director
            hash[:actual_address] = params[:actual_address]
            hash[:bank_details]   = params[:bank_details]
          end
        end

        # Возвращает полное имя руководителя юридического лица
        # @return [String]
        #   полное имя руководителя юридического лица
        def director
          params
            .values_at(:chief_surname, :chief_name, :chief_middle_name)
            .find_all(&:present?)
            .join(' ')
        end
      end
    end
  end
end
