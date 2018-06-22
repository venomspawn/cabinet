# frozen_string_literal: true

# Фабрика ассоциативных массивов с информацией об индивидуальных
# предпринимателях

FactoryBot.define do
  factory 'params/entrepreneur', class: Hash do
    commercial_name { create(:string) }
    ogrn            { create(:string, length: 15) }

    skip_create
    initialize_with { attributes }
  end
end
