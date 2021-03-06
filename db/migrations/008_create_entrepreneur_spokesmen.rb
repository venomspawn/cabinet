# frozen_string_literal: true

# Создание таблицы записей связей между записями индивидуальных
# предпринимателей и их представителей

Sequel.migration do
  change do
    create_table(:entrepreneur_spokesmen) do
      column :created_at, :timestamp, null: false

      foreign_key :spokesman_id, :individuals,
                  type:      :uuid,
                  null:      false,
                  index:     true,
                  on_delete: :restrict,
                  on_update: :cascade

      foreign_key :entrepreneur_id, :entrepreneurs,
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

      primary_key %i[spokesman_id entrepreneur_id vicarious_authority_id],
                  name: :entrepreneur_spokesmen_pkey
    end
  end
end
