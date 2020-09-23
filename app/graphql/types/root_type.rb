module Types
  class RootType < Types::BaseObject
    field :id, ID, null: false
    field :value, String, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
