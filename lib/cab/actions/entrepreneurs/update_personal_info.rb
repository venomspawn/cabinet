# frozen_string_literal: true

require 'securerandom'

module Cab
  need 'actions/base/action'

  module Actions
    module Entrepreneurs
      # Класс действий обновления персональных данных у записи индивидуального
      # предпринимателя
      class UpdatePersonalInfo < Base::Action
        require_relative 'update_personal_info/params_schema'

        # Обновляет персональные данные у записи индивидуального
        # предпринимателя и возвращает ассоциативный массив с информацией об
        # обновлённой записи
        # @return [Hash]
        #   результирующий ассоциативный массив
        def update
          Sequel::Model.db.transaction(savepoint: true) do
            update_individual
            document = create_identity_document
            { identity_document_id: document.id }
          end
        end

        private

        # Возвращает значение параметра `id`
        # @return [String]
        #   значение параметра `id`
        def id
          params[:id]
        end

        # Возвращает запись индивидуального предпринимателя
        # @return [Cab::Models::Entrepreneur]
        #   запись индивидуального предпринимателя
        # @raise [Sequel::NoMatchingRow]
        #   если запись индивидуального предпринимателя не найдена
        def record
          Models::Entrepreneur.select(:individual_id).with_pk!(id)
        end

        # Обновляет поля записи физического лица, к которой прикреплена запись
        # индивидуального предпринимателя
        def update_individual
          Models::Individual
            .where(id: record.individual_id)
            .update(individual_params)
        end

        # Ассоциативный массив, отображающий названия ключей ассоциативного
        # массива атрибутов записи физического лица в названия ключей
        # ассоциативного массива параметров
        INDIVIDUAL_FIELDS = {
          name:        :first_name,
          surname:     :last_name,
          middle_name: :middle_name,
          birth_place: :birth_place,
          sex:         :sex,
          citizenship: :citizenship
        }.freeze

        # Возвращает ассоциативный массив полей записи физического лица
        # @return [Hash]
        #   результирующий ассоциативный массив
        def individual_params
          extract_params(INDIVIDUAL_FIELDS).tap do |hash|
            # '20.07.2018' ~> '2018-07-20'
            hash[:birthday] = params[:birth_date].split('.').reverse.join('-')
          end
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
            hash[:individual_id] = record.individual_id
          end
        end
      end
    end
  end
end
