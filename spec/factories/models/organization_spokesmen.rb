# frozen_string_literal: true

# Фабрика записей связей между записями организаций и их представителей

FactoryBot.define do
  factory :organization_spokesman, class: Cab::Models::OrganizationSpokesman do
    created_at             { Time.now }
    spokesman_id           { create(:individual).id }
    organization_id        { create(:organization).id }
    vicarious_authority_id { create(:vicarious_authority).id }
  end
end
