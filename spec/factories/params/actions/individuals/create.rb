# frozen_string_literal: true

# Фабрика ассоциативных массивов с параметрами действия создания записи
# физического лица

FactoryBot.define do
  factory 'params/actions/individuals/create', class: Hash do
    first_name            { create(:string) }
    last_name             { create(:string) }
    middle_name           { create(:string) }
    birth_place           { create(:string) }
    birth_date            { create(:date).to_s }
    sex                   { create(:enum, values: %w[male female]) }
    citizenship           { create(:enum, values: %w[russian foreign absent]) }
    snils                 { create(:snils) }
    inn                   { create(:string, length: 12) }
    registration_address  { create(:address) }
    residential_address   { create(:address) }
    identity_document     { create('params/identity_document') }
    consent_to_processing { [content: create(:string)] }

    trait :with_spokesman do
      spokesman { create('params/spokesman') }
    end

    skip_create
    initialize_with { attributes }
  end
end
