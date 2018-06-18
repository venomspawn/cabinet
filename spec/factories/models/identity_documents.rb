# frozen_string_literal: true

# Фабрика записей документов, удостоверяющих личность

types = Cab::Models::IdentityDocument::TYPES

FactoryBot.define do
  factory :identity_document, class: Cab::Models::IdentityDocument do
    id             { create(:uuid) }
    type           { create(:enum, values: types) }
    number         { create(:string) }
    series         { create(:string) }
    issued_by      { create(:string) }
    issue_date     { create(:date) }
    expiration_end { create(:date) }
    division_code  { create(:string) }
    content        { create(:string) }
    created_at     { Time.now }
    individual_id  { create(:individual).id }
  end
end
