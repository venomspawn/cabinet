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

        # Создаёт запись документа, подтверждающего полномочия представителя,
        # после чего создаёт запись связи между записями юридического лица,
        # представителя и созданного документа
        def create
          Sequel::Model.db.transaction(savepoint: true) do
            vicarious_authority = create_vicarious_authority
            create_organization_spokesman(vicarious_authority)
          end
        end

        private

        # Создаёт и возвращает запись документа, подтверждающего полномочия
        # представителя юридического лица
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
          name:            :title,
          number:          :number,
          series:          :series,
          registry_number: :registry_number,
          issued_by:       :issued_by,
          issue_date:      :issue_date,
          expiration_date: :due_date,
          file_id:         :file_id,
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
        # @param [Models::VicariousAuthority] vicarious_authority
        #   запись документа, подтверждающего полномочия представителя
        def create_organization_spokesman(vicarious_authority)
          link_params = organization_spokesman_params(vicarious_authority)
          create_unrestricted(:OrganizationSpokesman, link_params)
        end

        # Ассоциативный массив, в котором сопоставляются названия полей записи
        # связи между записями физического лица и его представителя и способы
        # извлечения значений этих полей из параметров действия
        LINK_FIELDS = {
          created_at:      Time.method(:now),
          spokesman_id     :spokesman_id,
          organization_id: :id
        }.freeze

        # Возвращает ассоциативный массив полей записи связи между записями
        # юридического лица и его представителя
        # @param [Cab::Models::VicariousAuthority] vicarious_authority
        #   запись документа, подтверждающего полномочия представителя
        # @return [Hash]
        #   результирующий ассоциативный массив
        def organization_spokesman_params(vicarious_authority)
          extract_params(LINK_FIELDS).tap do |hash|
            hash[:vicarious_authority_id] = vicarious_authority.id
          end
        end
      end
    end
  end
end
