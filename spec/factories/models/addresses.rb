# frozen_string_literal: true

# Фабрика адресов

FactoryBot.define do
  factory :address, class: Hash do
    zip        { create(:string) }
    country    { create(:string) }
    region     { create(:string) }
    sub_region { create(:string) }
    city       { create(:string) }
    settlement { create(:string) }
    street     { create(:string) }
    house      { create(:string) }
    building   { create(:string) }
    appartment { create(:string) }

    skip_create
    initialize_with { attributes }
  end
end
