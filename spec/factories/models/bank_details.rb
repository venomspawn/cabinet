# frozen_string_literal: true

# Фабрика банковских реквизитов

FactoryBot.define do
  factory :bank_details, class: Hash do
    checking_account      { create(:string) }
    correspondent_account { create(:string) }
    bank_name             { create(:string) }
    bik                   { create(:string) }

    skip_create
    initialize_with { attributes }
  end
end
