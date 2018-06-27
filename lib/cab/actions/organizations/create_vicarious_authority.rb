# frozen_string_literal: true

require 'securerandom'

module Cab
  need 'actions/base/action'

  module Actions
    module Organizations
      # Класс действий создания записи документа, подтверждающего полномочия
      # представителя юридического лица
      class CreateVicariousAuthority < Base::Action
        require_relative 'create_vicarious_authority/params_schema'

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

        # Создаёт запись документа, подтверждающего полномочия представителя,
        # создаёт запись связи между записями юридического лица, представителя
        # и созданного документа, после чего возвращает ассоциативный массив с
        # информацией о созданной записи связи
        # @return [Hash]
        #   результирующий ассоциативный массив
        def create
          Sequel::Model.db.transaction(savepoint: true) do
            vicarious_authority = create_vicarious_authority
            create_organization_spokesman(vicarious_authority)
            values(vicarious_authority)
          end
        end

        private

        # Идентификатор записи
        # @return [String] id
        #   идентификатор записи
        attr_reader :id

        # Возвращает запись юридического лица
        # @return [Cab::Models::Organization]
        #   запись юридического лица
        # @raise [Sequel::NoMatchingRow]
        #   если запись юридического лица не найдена
        def record
          Models::Organization.select(:id).with_pk!(id)
        end

        # Возвращает запись представителя
        # @return [Cab::Models::Individual]
        #   запись представителя
        # @raise [Sequel::NoMatchingRow]
        #   если запись представителя не найдена
        def spokesman
          @spokesman ||= Models::Individual.select(:id).with_pk!(params[:id])
        end

        # Создаёт и возвращает запись документа, подтверждающего полномочия
        # представителя юридического лица
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
          param = params[:power_of_attorney]
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
        # @param [Models::VicariousAuthority] vicarious_authority
        #   запись документа, подтверждающего полномочия представителя
        def create_organization_spokesman(vicarious_authority)
          link_params = organization_spokesman_params(vicarious_authority)
          Models::OrganizationSpokesman.unrestrict_primary_key
          Models::OrganizationSpokesman.create(link_params)
          Models::OrganizationSpokesman.restrict_primary_key
        end

        # Возвращает ассоциативный массив полей записи связи между записями
        # юридического лица и его представителя
        # @param [Cab::Models::VicariousAuthority] vicarious_authority
        #   запись документа, подтверждающего полномочия представителя
        # @return [Hash]
        #   результирующий ассоциативный массив
        def organization_spokesman_params(vicarious_authority)
          {
            created_at:             Time.now,
            spokesman_id:           spokesman.id,
            organization_id:        record.id,
            vicarious_authority_id: vicarious_authority.id
          }
        end

        # Возвращает ассоциативный массив атрибутов записи связи между записями
        # юридического лица, его представителя и документа, подтверждающего
        # полномочия представителя
        # @param [Cab::Models::VicariousAuthority] vicarious_authority
        #   запись документа, подтверждающего полномочия представителя
        # @return [Hash]
        #   результирующий ассоциативный массив
        def values(vicarious_authority)
          {}.tap do |hash|
            hash[:applicant_id] = record.id
            hash[:spokesman_id] = spokesman.id
            hash[:power_of_attorney] =
              { files: [content: vicarious_authority.content] }
          end
        end
      end
    end
  end
end
