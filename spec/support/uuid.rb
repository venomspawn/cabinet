# frozen_string_literal: true

# Добавление конструкций RSpec для проверки строкового представления объекта на
# соответствие формату UUID

hex = '[0-9a-fA-F]'
uuid_format = /\A#{hex}{8}-#{hex}{4}-#{hex}{4}-#{hex}{4}-#{hex}{12}\z/
RSpec::Matchers.define :match_uuid_format do
  match { |obj| obj.to_s =~ uuid_format }

  failure_message { |obj| "expected that #{obj} would match UUID format" }

  description { 'match UUID format' }
end
