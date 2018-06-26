# frozen_string_literal: true

# Фабрика ассоциативных массивов с параметрами действия обновления персональных
# данных в записи физического лица

FactoryBot.define do
  factory 'params/actions/individuals/update_personal_info', class: Hash do
    first_name            { create(:string) }
    last_name             { create(:string) }
    middle_name           { create(:string) }
    birth_place           { create(:string) }
    birth_date            { create(:date).strftime('%d.%m.%Y') }
    sex                   { create(:enum, values: %w[male female]) }
    citizenship           { create(:enum, values: %w[russian foreign absent]) }
    identity_document     { create('params/identity_document') }

    skip_create
    initialize_with { attributes }
  end
end
