# frozen_string_literal: true

# Создание таблицы записей связей между записями организаций и их
# представителей

Sequel.migration do
  change do
    create_table(:organization_spokesmen) do
      column :created_at, :timestamp, null: false

      foreign_key :spokesman_id, :individuals,
                  type:      :uuid,
                  null:      false,
                  index:     true,
                  on_delete: :restrict,
                  on_update: :cascade

      foreign_key :organization_id, :organizations,
                  type:      :uuid,
                  null:      false,
                  index:     true,
                  on_delete: :restrict,
                  on_update: :cascade

      foreign_key :vicarious_authority_id, :vicarious_authorities,
                  type:      :uuid,
                  null:      false,
                  index:     true,
                  on_delete: :restrict,
                  on_update: :cascade

      primary_key %i[spokesman_id organization_id vicarious_authority_id],
                  name: :organization_spokesmen_pkey
    end
  end
end
