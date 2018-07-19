# frozen_string_literal: true

require 'securerandom'

module Cab
  need 'actions/base/record_action'

  module Actions
    module Individuals
      # Класс действий обновления персональных данных у записи физического лица
      class UpdatePersonalInfo < Base::RecordAction
        require_relative 'update_personal_info/params_schema'

        # Обновляет персональные данные у записи физического лица и возвращает
        # ассоциативный массив с информацией об обновлённой записи
        # @return [Hash]
        #   результирующий ассоциативный массив
        def update
          Sequel::Model.db.transaction(savepoint: true) do
            record.update(individual_params)
            document = create_identity_document
            { identity_document_id: document.id }
          end
        end

        private

        # Возвращает запись физического лица
        # @return [Cab::Models::Individual]
        #   запись физического лица
        # @raise [Sequel::NoMatchingRow]
        #   если запись физического лица не найдена
        def record
          @record ||= Models::Individual.select(:id).with_pk!(id)
        end

        # Ассоциативный массив, отображающий названия ключей ассоциативного
        # массива атрибутов записи физического лица в названия ключей
        # ассоциативного массива параметров
        INDIVIDUAL_FIELDS = {
          name:        :first_name,
          surname:     :last_name,
          middle_name: :middle_name,
          birth_place: :birth_place,
          birthday:    :birth_date,
          sex:         :sex,
          citizenship: :citizenship
        }.freeze

        # Возвращает ассоциативный массив полей записи физического лица
        # @return [Hash]
        #   результирующий ассоциативный массив
        def individual_params
          extract_params(INDIVIDUAL_FIELDS)
        end

        # Создаёт запись документа, удостоверяющего личность физического лица
        def create_identity_document
          create_unrestricted(:IdentityDocument, identity_document_params)
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
        # @return [Hash]
        #   результирующий ассоциативный массив
        def identity_document_params
          extract_params(IDENTITY_DOCUMENT_FIELDS).tap do |hash|
            hash[:individual_id] = record.id
          end
        end
      end
    end
  end
end
