# frozen_string_literal: true

# Фабрика записей организаций

FactoryBot.define do
  factory :organization, class: Cab::Models::Organization do
    id                { create(:uuid) }
    full_name         { create(:string) }
    short_name        { create(:string) }
    director          { create(:string) }
    registration_date { create(:date) }
    inn               { create(:string, length: 10) }
    kpp               { create(:string, length: 9) }
    ogrn              { create(:string, length: 13) }
    legal_address     { create(:address) }
    actual_address    { create(:address) }
    bank_details      { create(:bank_details) }
  end
end
