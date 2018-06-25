# frozen_string_literal: true

# Фабрика ассоциативных массивов с параметрами действия создания записи
# юридического лица

FactoryBot.define do
  factory 'params/actions/organizations/create', class: Hash do
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
    spokesman         { create('params/spokesman') }

    skip_create
    initialize_with { attributes }
  end
end
