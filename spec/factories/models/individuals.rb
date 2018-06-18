# frozen_string_literal: true

# Фабрика записей физических лиц

FactoryBot.define do
  factory :individual, class: Cab::Models::Individual do
    id                     { create(:uuid) }
    name                   { create(:string) }
    surname                { create(:string) }
    middle_name            { create(:string) }
    birth_place            { create(:string) }
    birthday               { create(:date) }
    sex                    { create(:enum, values: %w[male female]) }
    citizenship            { create(:enum, values: %w[russian foreign]) }
    snils                  { create(:snils) }
    inn                    { create(:string, length: 12) }
    registration_address   { create(:address) }
    residence_address      { create(:address) }
    temp_residence_address { create(:address) }
    agreement              { create(:string) }
    created_at             { Time.now }
  end
end
