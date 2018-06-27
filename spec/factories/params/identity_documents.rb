# frozen_string_literal: true

# Фабрика ассоциативных массивов с информацией о документе, удостоверяющем
# личность

FactoryBot.define do
  factory 'params/identity_document', class: Hash do
    type       { create(:enum, values: Cab::Models::IdentityDocument::TYPES) }
    number     { create(:string) }
    series     { create(:string) }
    issued_by  { create(:string) }
    issue_date { create(:date).to_s }
    due_date   { create(:date).to_s }
    content    { create(:string) }

    skip_create
    initialize_with { attributes }
  end
end
