# frozen_string_literal: true

# Создание таблицы записей организаций

Sequel.migration do
  change do
    create_table(:organizations) do
      column :id,                :uuid, primary_key: true
      column :full_name,         :text, null: false
      column :short_name,        :text
      column :chief_name,        :text, null: false
      column :chief_surname,     :text, null: false
      column :chief_middle_name, :text
      column :registration_date, :date, null: false
      column :inn,               :text, null: false
      column :kpp,               :text, null: false
      column :ogrn,              :text, null: false
      column :legal_address,     :jsonb, null: false
      column :actual_address,    :jsonb
      column :bank_details,      :jsonb
      column :created_at,        :timestamp, null: false

      index :full_name,
            name:    :organizations_full_name_trgm_index,
            type:    :gist,
            opclass: :gist_trgm_ops

      index :legal_address,
            name:    :organizations_legal_address_path_index,
            type:    :gin,
            opclass: :jsonb_path_ops

      constraint :organizations_inn_format, :inn.like(/\A[0-9]{10}\Z/)
      constraint :organizations_kpp_format, :kpp.like(/\A[0-9]{9}\Z/)
      constraint :organizations_ogrn_format, :ogrn.like(/\A[0-9]{13}\Z/)
    end
  end
end
