# frozen_string_literal: true

# Фабрика ассоциативных массивов с информацией о представителе

FactoryBot.define do
  factory 'params/spokesman', class: Hash do
    id              { create(:individual).id }
    title           { create(:string) }
    number          { create(:string) }
    series          { create(:string) }
    registry_number { create(:string) }
    issued_by       { create(:string) }
    issue_date      { create(:date).to_s }
    due_date        { create(:date).to_s }
    content         { create(:string) }

    skip_create
    initialize_with { attributes }
  end
end
