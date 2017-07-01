Types::JSONType = GraphQL::ScalarType.define do
  name "JSON"

  description "Parsing JSON"

  coerce_input ->(value, _ctx) { JSON.parse(value) }
  coerce_result ->(value, _ctx) { value.to_json }
end
