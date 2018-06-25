# frozen_string_literal: true

# Фабрика ассоциативных массивов с параметрами действия обновления полей записи
# юридического лица

FactoryBot.define do
  factory 'params/actions/organizations/update', class: Hash do
    full_name         { create(:string) }
    sokr_name         { create(:string) }
    chief_name        { create(:string) }
    chief_surname     { create(:string) }
    chief_middle_name { create(:string) }
    registration_date { create(:date).strftime('%d.%m.%Y') }
    inn               { create(:string, length: 10) }
    kpp               { create(:string, length: 9) }
    ogrn              { create(:string, length: 13) }
    legal_address     { create(:address) }
    actual_address    { create(:address) }
    bank_details      { create(:bank_details) }

    skip_create
    initialize_with { attributes }
  end
end
