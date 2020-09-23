module Types
  class LemmaType < Types::BaseObject
    field :id, ID, null: false
    field :text_madani, String, null: true
    field :text_clean, String, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
