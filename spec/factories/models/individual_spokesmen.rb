# frozen_string_literal: true

# Фабрика записей связей между записями физических лиц и их представителей

FactoryBot.define do
  factory :individual_spokesman, class: Cab::Models::IndividualSpokesman do
    created_at             { Time.now }
    spokesman_id           { create(:individual).id }
    individual_id          { create(:individual).id }
    vicarious_authority_id { create(:vicarious_authority).id }
  end
end
