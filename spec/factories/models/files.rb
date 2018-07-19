# frozen_string_literal: true

# Фабрика записей файлов

FactoryBot.define do
  factory :file, class: Cab::Models::File do
    id         { create(:uuid) }
    content    { create(:string) }
    created_at { Time.now }
  end
end
