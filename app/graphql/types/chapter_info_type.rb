module Types
  class ChapterInfoType < Types::BaseObject
    field :id, ID, null: false
    field :chapter_id, Integer, null: true
    field :text, String, null: true
    field :source, String, null: true
    field :short_text, String, null: true
    field :language_id, Integer, null: true
    field :resource_content_id, Integer, null: true
    field :language_name, String, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
