# frozen_string_literal: true

# Фабрика ассоциативных массивов с параметрами действия обновления содержимого
# файла документа, удостоверяющего личность

FactoryBot.define do
  factory 'params/actions/documents/update', class: Hash do
    content { create(:string) }

    trait :with_id do
      id { create(:uuid) }
    end

    skip_create
    initialize_with { attributes }
  end
end
