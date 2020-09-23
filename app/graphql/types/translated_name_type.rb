module Types
  class TranslatedNameType < Types::BaseObject
    field :id, ID, null: false
    field :resource_type, String, null: true
    field :resource_id, Integer, null: true
    field :language_id, Integer, null: true
    field :name, String, null: true
    field :language_name, String, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :language_priority, Integer, null: true
  end
end
