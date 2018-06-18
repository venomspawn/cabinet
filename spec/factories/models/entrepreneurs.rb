# frozen_string_literal: true

# Фабрика записей индивидуальных предпринимателей

FactoryBot.define do
  factory :entrepreneur, class: Cab::Models::Entrepreneur do
    id              { create(:uuid) }
    commercial_name { create(:string) }
    ogrn            { create(:string, length: 15) }
    bank_details    { create(:bank_details) }
    actual_address  { create(:address) }
    created_at      { Time.now }
    individual_id   { create(:individual).id }
  end
end
