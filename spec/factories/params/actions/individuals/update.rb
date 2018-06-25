# frozen_string_literal: true

# Фабрика ассоциативных массивов с параметрами действия обновления полей записи
# физического лица

FactoryBot.define do
  factory 'params/actions/individuals/update', class: Hash do
    snils                 { create(:snils) }
    inn                   { create(:string, length: 12) }
    registration_address  { create(:address) }
    residential_address   { create(:address) }

    skip_create
    initialize_with { attributes }
  end
end
