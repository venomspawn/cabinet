# frozen_string_literal: true

# Фабрика ассоциативных массивов с параметрами действия создания записи связи
# между записями физического лица, его представителя и документа,
# подтверждающего полномочия представителя

FactoryBot.define do
  name = 'params/actions/individuals/create_vicarious_authority'
  factory name, class: Hash do
    id                { create(:individual).id }
    power_of_attorney { create('params/power_of_attorney') }

    skip_create
    initialize_with { attributes }
  end
end
