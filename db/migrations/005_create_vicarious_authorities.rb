# frozen_string_literal: true

# Создание таблицы записей документов, подтверждающих полномочия представителя

Sequel.migration do
  change do
    create_table(:vicarious_authorities) do
      column :id,              :uuid, primary_key: true
      column :name,            :text, null: false
      column :number,          :text
      column :series,          :text
      column :registry_number, :text
      column :issued_by,       :text, null: false
      column :issue_date,      :date, null: false
      column :expiration_date, :date
      column :content,         :bytea, null: false
      column :created_at,      :timestamp, null: false
    end
  end
end
