# frozen_string_literal: true

# Создание таблицы записей индивидуальных предпринимателей

Sequel.migration do
  change do
    create_table(:entrepreneurs) do
      column :id,              :uuid, primary_key: true
      column :commerical_name, :text
      column :ogrn,            :text, null: false
      column :bank_details,    :jsonb
      column :actual_address,  :jsonb, null: false

      constraint :entrepreneurs_ogrn_format, :ogrn.like(/^[0-9]{15}$/)

      foreign_key :individual_id, :individuals,
                  type:      :uuid,
                  null:      false,
                  unique:    true,
                  on_delete: :cascade,
                  on_update: :cascade
    end
  end
end
