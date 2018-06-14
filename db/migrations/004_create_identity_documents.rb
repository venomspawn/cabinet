# frozen_string_literal: true

# Создание таблицы записей документов, удостоверяющих личность

Sequel.migration do
  change do
    create_enum :identity_document_type, %i[
      foreign_citizen_passport
      residence
      temporary_residence
      refugee_certificate
      certificate_of_temporary_asylum_rf
      passport_rf
      international_passport
      seaman_passport
      officer_identity_document
      soldier_identity_document
      temporary_identity_card
      birth_certificate
    ]

    create_table(:identity_documents) do
      column :id,             :uuid, primary_key: true
      column :type,           :identity_document_type, null: false
      column :number,         :text
      column :series,         :text, null: false
      column :issued_by,      :text, null: false
      column :issue_date,     :date, null: false
      column :expiration_end, :date
      column :division_code,  :text
      column :content,        :bytea, null: false

      foreign_key :individual_id, :individuals,
                  type:      :uuid,
                  null:      false,
                  on_delete: :cascade,
                  on_update: :cascade
    end
  end
end
