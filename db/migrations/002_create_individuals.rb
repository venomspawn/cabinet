# frozen_string_literal: true

# Создание таблицы записей физических лиц

Sequel.migration do
  change do
    create_enum :sex, %i[male female]
    create_enum :citizenship, %i[russian foreign absent]

    create_table(:individuals) do
      column :id,                     :uuid, primary_key: true
      column :name,                   :text, null: false, index: true
      column :surname,                :text, null: false, index: true
      column :middle_name,            :text, index: true
      column :birth_place,            :text, null: false, index: true
      column :birthday,               :date, null: false, index: true
      column :sex,                    :sex, null: false
      column :citizenship,            :citizenship, null: false
      column :snils,                  :text, index: true
      column :inn,                    :text, index: true
      column :registration_address,   :jsonb
      column :residence_address,      :jsonb, null: false
      column :temp_residence_address, :jsonb
      column :agreement,              :bytea, null: false
      column :created_at,             :timestamp, null: false

      index :name,
            name:    :individuals_name_trgm_index,
            type:    :gist,
            opclass: :gist_trgm_ops

      index :surname,
            name:    :individuals_surname_trgm_index,
            type:    :gist,
            opclass: :gist_trgm_ops

      index :middle_name,
            name:    :individuals_middle_name_trgm_index,
            type:    :gist,
            opclass: :gist_trgm_ops

      index :birth_place,
            name:    :individuals_birth_place_trgm_index,
            type:    :gist,
            opclass: :gist_trgm_ops

      constraint :individuals_snils_format,
                 :snils.like(/\A[0-9]{3}-[0-9]{3}-[0-9]{3} [0-9]{2}\Z/)

      constraint :individuals_inn_format, :inn.like(/\A[0-9]{12}\Z/)
    end
  end
end
