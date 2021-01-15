class QuranApiSchema < GraphQL::Schema
  # mutation(Types::MutationType)
  query(Types::QueryType)

  # Opt in to the new runtime (default in future graphql-ruby versions)
  use GraphQL::Execution::Interpreter
  use GraphQL::Analysis::AST

  # Add built-in connections for pagination
  use GraphQL::Pagination::Connections

  # Performance tracing
  if Rails.env.development?
    use ApolloTracing.new
  end
end
