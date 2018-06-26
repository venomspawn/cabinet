# frozen_string_literal: true

# Фабрика ассоциативных массивов с параметрами действия обновления содержимого
# файла документа, удостоверяющего личность

FactoryBot.define do
  factory 'params/actions/documents/update', class: Array do
    transient { content { create(:string) } }
    transient { with_id { false } }

    trait :with_id do
      transient { with_id { true } }
    end

    skip_create
    initialize_with do
      with_id ? [content: content, id: create(:uuid)] : [content: content]
    end
  end
end
