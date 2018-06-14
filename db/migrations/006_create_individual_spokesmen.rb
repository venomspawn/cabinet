# frozen_string_literal: true

# Создание таблицы записей связей между записями физических лиц и их
# представителей

Sequel.migration do
  change do
    create_table(:individual_spokesmen) do
      foreign_key :spokesman_id, :individuals,
                  type:      :uuid,
                  null:      false,
                  index:     true,
                  on_delete: :cascade,
                  on_update: :cascade

      foreign_key :individual_id, :individuals,
                  type:      :uuid,
                  null:      false,
                  index:     true,
                  on_delete: :cascade,
                  on_update: :cascade

      foreign_key :vicarious_authority_id, :vicarious_authorities,
                  type:      :uuid,
                  null:      false,
                  index:     true,
                  on_delete: :cascade,
                  on_update: :cascade
    end
  end
end