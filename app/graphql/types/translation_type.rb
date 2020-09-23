module Types
  class TranslationType < Types::BaseObject
    field :id, ID, null: false
    field :language_id, Integer, null: true
    field :text, String, null: true
    field :resource_content_id, Integer, null: true
    field :resource_type, String, null: true
    field :resource_id, Integer, null: true
    field :language_name, String, null: true
    field :priority, Integer, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :resource_name, String, null: true
  end
end
