# frozen_string_literal: true

QuranAPISchema = GraphQL::Schema.define do
  query(Types::QueryType)

  # GraphQL::Batch setup:
  use GraphQL::Batch

  instrument(:field, GraphQL::Models::Instrumentation.new)
end
