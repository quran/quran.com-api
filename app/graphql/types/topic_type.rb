module Types
  class TopicType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: true
    field :parent_id, Integer, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
