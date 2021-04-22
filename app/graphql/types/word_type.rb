# frozen_string_literal: true

module Types
  class WordType < Types::BaseObject
    field :id, ID, null: false
    field :verse_id, Integer, null: true
    field :chapter_id, Integer, null: true
    field :position, Integer, null: true
    field :text_uthmani, String, null: true
    field :text_indopak, String, null: true
    field :text_simple, String, null: true
    field :text_imlaei, String, null: true
    field :verse_key, String, null: true
    field :class_name, String, null: true
    field :line_number, Integer, null: true
    field :code, String, null: true
    field :location, String, null: true
    field :audio_url, String, null: true
    field :char_type_name, String, null: true

    field :page_number, Integer, null: true
    field :v1_page, Integer, null: true
    field :v2_page, Integer, null: true

    field :translation, Types::WordTranslationType, "word translation in given language. If translation for give language doesn't exist, we'll fallback to English translation", null: true

    def translation
      object.word_translation
    end
  end
end
