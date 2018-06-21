# frozen_string_literal: true

# Фабрика ассоциативных массивов с информацией о документах, подтверждающих
# полномочия представителя

FactoryBot.define do
  factory 'params/power_of_attorney', class: Hash do
    title           { create(:string) }
    number          { create(:string) }
    series          { create(:string) }
    registry_number { create(:string) }
    issued_by       { create(:string) }
    issue_date      { create(:date).to_s }
    due_date        { create(:date).to_s }
    files           { [content: create(:string)] }
  end
end
