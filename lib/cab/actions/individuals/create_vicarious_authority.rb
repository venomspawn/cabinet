# frozen_string_literal: true

require 'securerandom'

module Cab
  need 'actions/base/record_action'

  module Actions
    module Individuals
      # Класс действий создания записи документа, подтверждающего полномочия
      # представителя физического лица
      class CreateVicariousAuthority < Base::RecordAction
        require_relative 'create_vicarious_authority/params_schema'

        # Создаёт запись документа, подтверждающего полномочия представителя,
        # после чего создаёт запись связи между записями физического лица,
        # представителя и созданного документа
        def create
          Sequel::Model.db.transaction(savepoint: true) do
            vicarious_authority = create_vicarious_authority
            create_individual_spokesman(vicarious_authority)
          end
        end

        private

        # Возвращает запись физического лица
        # @return [Cab::Models::Individual]
        #   запись физического лица
        # @raise [Sequel::NoMatchingRow]
        #   если запись физического лица не найдена
        def record
          Models::Individual.select(:id).with_pk!(id)
        end

        # Возвращает запись представителя
        # @return [Cab::Models::Individual]
        #   запись представителя
        # @raise [Sequel::NoMatchingRow]
        #   если запись представителя не найдена
        def spokesman
          Models::Individual.select(:id).with_pk!(params[:spokesman_id])
        end

        # Создаёт и возвращает запись документа, подтверждающего полномочия
        # представителя физического лица
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
          content:         :content,
          created_at:      Time.method(:now)
        }.freeze

        # Возвращает ассоциативный массив полей записи документа,
        # подтверждающего полномочия представителя
        # @return [Hash]
        #   результирующий ассоциативный массив
        def vicarious_authority_params
          extract_params(VICARIOUS_AUTHORITY_FIELDS)
        end

        # Создаёт запись связи между записями физического лица и его
        # представителя
        # @param [Cab::Models::Individual] record
        #   запись физического лица
        # @param [Models::VicariousAuthority] vicarious_authority
        #   запись документа, подтверждающего полномочия представителя
        def create_individual_spokesman(vicarious_authority)
          link_params = individual_spokesman_params(vicarious_authority)
          create_unrestricted(:IndividualSpokesman, link_params)
        end

        # Возвращает ассоциативный массив полей записи связи между записями
        # физического лица и его представителя
        # @param [Cab::Models::VicariousAuthority] vicarious_authority
        #   запись документа, подтверждающего полномочия представителя
        # @return [Hash]
        #   результирующий ассоциативный массив
        def individual_spokesman_params(vicarious_authority)
          {
            created_at:             Time.now,
            spokesman_id:           spokesman.id,
            individual_id:          record.id,
            vicarious_authority_id: vicarious_authority.id
          }
        end
      end
    end
  end
end
