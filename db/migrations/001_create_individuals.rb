# frozen_string_literal: true

# Создание таблицы записей физических лиц

Sequel.migration do
  change do
    create_enum :sex, %i[male female]
    create_enum :citizenship, %i[russian foreign absent]

    create_table(:individuals) do
      column :id,                     :uuid, primary_key: true
      column :name,                   :text, null: false
      column :surname,                :text, null: false
      column :middle_name,            :text
      column :birth_place,            :text, null: false
      column :birthday,               :date, null: false
      column :sex,                    :sex, null: false
      column :citizenship,            :citizenship, null: false
      column :snils,                  :text
      column :inn,                    :text
      column :registration_address,   :jsonb
      column :residence_address,      :jsonb, null: false
      column :temp_residence_address, :jsonb
      column :agreement,              :bytea, null: false
      column :created_at,             :timestamp, null: false

      constraint :individuals_snils_format,
                 :snils.like(/^[0-9]{3}-[0-9]{3}-[0-9]{3} [0-9]{2}$/)

      constraint :individuals_inn_format, :inn.like(/^[0-9]{12}$/)
    end
  end
end
