# frozen_string_literal: true

# Фабрика ассоциативных массивов с информацией о представителе

FactoryBot.define do
  factory 'params/spokesman', class: Hash do
    id                { create(:individual).id }
    power_of_attorney { create('params/power_of_attorney') }

    skip_create
    initialize_with { attributes }
  end
end
