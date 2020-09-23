module Types
  class VerseType < Types::BaseObject
    field :id, ID, null: false
    field :chapter_id, Integer, null: true
    field :verse_number, Integer, null: true
    field :verse_index, Integer, null: true
    field :verse_key, String, null: true
    field :text_madani, String, null: true
    field :text_indopak, String, null: true
    field :text_simple, String, null: true
    field :text_imlaei, String, null: true
    field :juz_number, Integer, null: true
    field :hizb_number, Integer, null: true
    field :rub_number, Integer, null: true
    field :sajdah, String, null: true
    field :sajdah_number, Integer, null: true
    field :page_number, Integer, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :image_url, String, null: true
    field :image_width, Integer, null: true
    field :verse_root_id, Integer, null: true
    field :verse_lemma_id, Integer, null: true
    field :verse_stem_id, Integer, null: true
  end
end
