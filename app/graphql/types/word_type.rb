module Types
  class WordType < Types::BaseObject
    field :id, ID, null: false
    field :verse_id, Integer, null: true
    field :chapter_id, Integer, null: true
    field :position, Integer, null: true
    field :text_madani, String, null: true
    field :text_indopak, String, null: true
    field :text_simple, String, null: true
    field :text_imlaei, String, null: true
    field :verse_key, String, null: true
    field :page_number, Integer, null: true
    field :class_name, String, null: true
    field :line_number, Integer, null: true
    field :code_dec, Integer, null: true
    field :code_hex, String, null: true
    field :code_hex_v3, String, null: true
    field :code_dec_v3, Integer, null: true
    field :char_type_id, Integer, null: true
    field :location, String, null: true
    field :audio_url, String, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :pause_name, String, null: true
    field :token_id, Integer, null: true
    field :topic_id, Integer, null: true
    field :char_type_name, String, null: true
  end
end
