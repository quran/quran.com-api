module Types
  class AudioFileType < Types::BaseObject
    field :id, ID, null: false
    field :resource_type, String, null: true
    field :resource_id, Integer, null: true
    field :url, String, null: true
    field :duration, Integer, null: true
    field :segments, String, null: true
    field :mime_type, String, null: true
    field :format, String, null: true
    field :is_enabled, Boolean, null: true
    field :recitation_id, Integer, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
