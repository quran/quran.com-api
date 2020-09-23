module Types
  class ChapterType < Types::BaseObject
    field :id, ID, null: false
    field :bismillah_pre, Boolean, null: true
    field :revelation_order, Integer, null: true
    field :revelation_place, String, null: true
    field :name_complex, String, null: true
    field :name_arabic, String, null: true
    field :name_simple, String, null: true
    field :pages, String, null: true
    field :verses_count, Integer, null: true
    field :chapter_number, Integer, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
