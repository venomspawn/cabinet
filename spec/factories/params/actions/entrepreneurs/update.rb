# frozen_string_literal: true

# Фабрика ассоциативных массивов с параметрами действия обновления полей записи
# индивидуального предпринимателя

FactoryBot.define do
  factory 'params/actions/entrepreneurs/update', class: Hash do
    snils                 { create(:snils) }
    inn                   { create(:string, length: 12) }
    registration_address  { create(:address) }
    actual_address        { create(:address) }
    bank_details          { create(:bank_details) }
    entrepreneur          { create('params/entrepreneur') }

    skip_create
    initialize_with { attributes }
  end
end
