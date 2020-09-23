module Types
  class RecitationType < Types::BaseObject
    field :id, ID, null: false
    field :reciter_id, Integer, null: true
    field :resource_content_id, Integer, null: true
    field :recitation_style_id, Integer, null: true
    field :reciter_name, String, null: true
    field :style, String, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
