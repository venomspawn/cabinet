# frozen_string_literal: true

# Добавление конструкций RSpec для проверки типов и структур объектов на
# соответствие JSON-схеме

require 'json-schema'

RSpec::Matchers.define :match_json_schema do |schema|
  match { |object| JSON::Validator.validate(schema, object) }

  failure_message do |object|
    str = JSON::Validator.fully_validate(schema, object).join('; ')
    "expected that #{object} would not bring following errors: #{str}"
  end

  description { "match JSON schema #{schema}" }
end

RSpec::Matchers.define :have_proper_body do |schema|
  match { |response| JSON::Validator.validate(schema, response.body) }

  failure_message do |response|
    str = JSON::Validator.fully_validate(schema, response.body).join('; ')
    "expected that #{response.body} would not bring following errors: #{str}"
  end

  description { "have body that matches JSON schema #{schema}" }
end
