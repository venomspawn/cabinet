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
          Sequel::Model.db.transaction(savepoint: true) do
            record = create_individual
            document = create_identity_document(record)
            vicarious_authority = create_vicarious_authority
            create_individual_spokesman(record, vicarious_authority)
            { id: record.id, identity_document_id: document.id }
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

        # Создаёт и возвращает запись физического лица
        # @return [Cab::Models::Individual]
        #   созданная запись физического лица
        def create_individual
          create_unrestricted(:Individual, individual_params)
        end

        # Ассоциативный массив, отображающий названия ключей ассоциативного
        # массива атрибутов записи физического лица в названия ключей
        # ассоциативного массива параметров
        INDIVIDUAL_FIELDS = {
          id:                   SecureRandom.method(:uuid),
          name:                 :first_name,
          surname:              :last_name,
          middle_name:          :middle_name,
          birth_place:          :birth_place,
          birthday:             :birth_date,
          sex:                  :sex,
          citizenship:          :citizenship,
          snils:                :snils,
          inn:                  :inn,
          registration_address: :registration_address,
          residence_address:    :residential_address,
          agreement_id:         :agreement_id,
          created_at:           Time.method(:now)
        }.freeze

        # Возвращает ассоциативный массив полей записи физического лица
        # @return [Hash]
        #   результирующий ассоциативный массив
        def individual_params
          extract_params(INDIVIDUAL_FIELDS)
        end

        # Создаёт запись документа, удостоверяющего личность физического лица
        # @param [Cab::Models::Individual] record
        #   запись физического лица
        def create_identity_document(record)
          document_params = identity_document_params(record)
          create_unrestricted(:IdentityDocument, document_params)
        end

        # Ассоциативный массив, в котором сопоставляются названия полей записи
        # документа, удостоверяющего личность, и способы извлечения значений
        # этих полей из параметров действия
        IDENTITY_DOCUMENT_FIELDS = {
          id:             SecureRandom.method(:uuid),
          type:           %i[identity_document type],
          name:           %i[identity_document title],
          number:         %i[identity_document number],
          series:         %i[identity_document series],
          issued_by:      %i[identity_document issued_by],
          issue_date:     %i[identity_document issue_date],
          expiration_end: %i[identity_document due_date],
          file_id:        %i[identity_document file_id],
          created_at:     Time.method(:now)
        }.freeze

        # Возвращает ассоциативный массив полей записи документа,
        # удостоверяющего личность
        # @param [Cab::Models::Individual] record
        #   запись физического лица
        # @return [Hash]
        #   результирующий ассоциативный массив
        def identity_document_params(record)
          extract_params(IDENTITY_DOCUMENT_FIELDS).tap do |hash|
            hash[:individual_id] = record.id
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
          create_unrestricted(:IndividualSpokesman, link_params)
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
            spokesman_id:           spokesman[:id],
            individual_id:          record.id,
            vicarious_authority_id: vicarious_authority.id
          }
        end
      end
    end
  end
end
