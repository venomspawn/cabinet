# frozen_string_literal: true

# Фабрика записей связей между записями индивидуальных предпринимателем и их
# представителей

FactoryBot.define do
  factory :entrepreneur_spokesman, class: Cab::Models::EntrepreneurSpokesman do
    spokesman_id           { create(:individual).id }
    entrepreneur_id        { create(:entrepreneur).id }
    vicarious_authority_id { create(:vicarious_authority).id }
  end
end
