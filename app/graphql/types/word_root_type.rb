module Types
  class WordRootType < Types::BaseObject
    field :id, ID, null: false
    field :word_id, Integer, null: true
    field :root_id, Integer, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
