Types::JSONType = GraphQL::ScalarType.define do
  name "JSONType"

  description "Parsing JSON"

  coerce_input ->(value, _ctx) { Oj.load(value) }
  coerce_result ->(value, _ctx) { Oj.load(value) }
end
