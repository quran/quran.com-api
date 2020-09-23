module Types
  class JuzType < Types::BaseObject
    field :id, ID, null: false
    field :juz_number, Integer, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :verse_mapping, GraphQL::Types::JSON, null: true
  end
end
