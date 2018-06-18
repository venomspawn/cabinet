# frozen_string_literal: true

# Создание таблицы записей организаций

Sequel.migration do
  change do
    create_table(:organizations) do
      column :id,                :uuid, primary_key: true
      column :full_name,         :text, null: false
      column :short_name,        :text
      column :director,          :text, null: false
      column :registration_date, :date, null: false
      column :inn,               :text, null: false
      column :kpp,               :text, null: false
      column :ogrn,              :text, null: false
      column :legal_address,     :jsonb, null: false
      column :actual_address,    :jsonb
      column :bank_details,      :jsonb
      column :created_at,        :timestamp, null: false

      constraint :organizations_inn_format, :inn.like(/^[0-9]{10}$/)
      constraint :organizations_kpp_format, :kpp.like(/^[0-9]{9}$/)
      constraint :organizations_ogrn_format, :ogrn.like(/^[0-9]{13}$/)
    end
  end
end
