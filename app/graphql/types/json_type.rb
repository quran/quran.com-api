# frozen_string_literal: true

Types::JSONType = GraphQL::ScalarType.define do
  name 'JSONType'

  description 'Parsing JSON'

  coerce_input ->(value, _ctx) { JSON.parse(value) }
  coerce_result ->(value, _ctx) { JSON.parse(value) }
end
