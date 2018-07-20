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
          Sequel::Model.db.transaction(savepoint: true) do
            record = create_organization
            vicarious_authority = create_vicarious_authority
            create_organization_spokesman(record, vicarious_authority)
            { id: record.id }
          end
        end

        private

        # Возвращает значение параметра `spokesman` или `nil`, если значение
        # параметра не указано
        # @return [Object]
        #   значение параметра `spokesman`
        def spokesman
          params[:spokesman]
        end

        # Создаёт и возвращает запись юридического лица
        # @return [Cab::Models::Organization]
        #   созданная запись юридического лица
        def create_organization
          create_unrestricted(:Organization, organization_params)
        end

        # Ассоциативный массив, отображающий названия ключей ассоциативного
        # массива атрибутов записи юридического лица в названия ключей
        # ассоциативного массива параметров
        ORGANIZATION_FIELDS = {
          id:                SecureRandom.method(:uuid),
          full_name:         :full_name,
          short_name:        :sokr_name,
          chief_name:        :chief_name,
          chief_surname:     :chief_surname,
          chief_middle_name: :chief_middle_name,
          registration_date: :registration_date,
          inn:               :inn,
          kpp:               :kpp,
          ogrn:              :ogrn,
          legal_address:     :legal_address,
          actual_address:    :actual_address,
          bank_details:      :bank_details,
          created_at:        Time.method(:now)
        }.freeze

        # Возвращает ассоциативный массив полей записи юридического лица
        # @return [Hash]
        #   результирующий ассоциативный массив
        def organization_params
          extract_params(ORGANIZATION_FIELDS)
        end

        # Создаёт и возвращает запись документа, подтверждающего полномочия
        # представителя
        # @return [Cab::Models::VicariousAuthority]
        #   запись документа, подтверждающего полномочия представителя
        def create_vicarious_authority
          create_unrestricted(:VicariousAuthority, vicarious_authority_params)
        end

        # Ассоциативный массив, в котором сопоставляются названия полей записи
        # документа, подтверждающего полномочия представителя, и способы
        # извлечения значений этих полей из параметров действия
        VICARIOUS_AUTHORITY_FIELDS = {
          id:              SecureRandom.method(:uuid),
          name:            %i[spokesman title],
          number:          %i[spokesman number],
          series:          %i[spokesman series],
          registry_number: %i[spokesman registry_number],
          issued_by:       %i[spokesman issued_by],
          issue_date:      %i[spokesman issue_date],
          expiration_date: %i[spokesman due_date],
          file_id:         %i[spokesman file_id],
          created_at:      Time.method(:now)
        }.freeze

        # Возвращает ассоциативный массив полей записи документа,
        # подтверждающего полномочия представителя
        # @return [Hash]
        #   результирующий ассоциативный массив
        def vicarious_authority_params
          extract_params(VICARIOUS_AUTHORITY_FIELDS)
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
          create_unrestricted(:OrganizationSpokesman, link_params)
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
            spokesman_id:           spokesman[:id],
            organization_id:        record.id,
            vicarious_authority_id: vicarious_authority.id
          }
        end
      end
    end
  end
end
