# frozen_string_literal: true

# Фабрика ассоциативных массивов с параметрами действия создания записи связи
# между записями юридического лица, его представителя и документа,
# подтверждающего полномочия представителя

FactoryBot.define do
  name = 'params/actions/organizations/create_vicarious_authority'
  factory name, class: Hash do
    spokesman_id    { create(:individual).id }
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
