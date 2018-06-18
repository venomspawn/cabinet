# frozen_string_literal: true

# Фабрика записей документов, подтверждающих полномочия представителя

FactoryBot.define do
  factory :vicarious_authority, class: Cab::Models::VicariousAuthority do
    id              { create(:uuid) }
    name            { create(:string) }
    number          { create(:string) }
    series          { create(:string) }
    registry_number { create(:string) }
    issued_by       { create(:string) }
    issue_date      { create(:date) }
    expiration_date { create(:date) }
    content         { create(:string) }
  end
end
