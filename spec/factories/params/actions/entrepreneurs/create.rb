# frozen_string_literal: true

# Фабрика ассоциативных массивов с параметрами действия создания записи
# индивидуального предпринимателя

FactoryBot.define do
  factory 'params/actions/entrepreneurs/create', class: Hash do
    actual_address  { create(:address) }
    bank_details    { create(:bank_details) }
    commercial_name { create(:string) }
    ogrn            { create(:string, length: 15) }

    trait :with_individual do
      first_name           { create(:string) }
      last_name            { create(:string) }
      middle_name          { create(:string) }
      birth_place          { create(:string) }
      birth_date           { create(:date).strftime('%d.%m.%Y') }
      sex                  { create(:enum, values: %w[male female]) }
      citizenship          { create(:enum, values: %w[russian foreign]) }
      snils                { create(:snils) }
      inn                  { create(:string, length: 12) }
      registration_address { create(:address) }
      identity_document    { create('params/identity_document') }
      agreement_id         { create(:file).id }
    end

    trait :with_individual_id do
      individual_id { create(:individual).id }
    end

    trait :with_spokesman do
      spokesman { create('params/spokesman') }
    end

    skip_create
    initialize_with { attributes }
  end
end
