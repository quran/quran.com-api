# frozen_string_literal: true

module Types
  class VerseType < Types::BaseObject
    field :id, ID, null: false
    field :chapter_id, Integer, null: true
    field :verse_number, Integer, null: true
    field :verse_index, Integer, null: true
    field :verse_key, String, null: true

    field :text_uthmani, String, null: true
    field :text_uthmani_tajweed, String, null: true
    field :text_uthmani_simple, String, null: true

    field :text_indopak, String, null: true

    field :text_imlaei, String, null: true
    field :text_imlaei_simple, String, null: true

    field :juz_number, Integer, null: true
    field :hizb_number, Integer, null: true
    field :rub_number, Integer, null: true
    field :sajdah_type, String, null: true
    field :sajdah_number, Integer, null: true
    field :page_number, Integer, null: true

    field :image_url, String, null: true
    field :image_width, Integer, null: true

    # field :pagintion, [Types::PaginationType], null: false

    field :words, [Types::WordType], 'words of the verse', null: true
    field :tafsirs, [Types::TafsirType], 'tafsirs of the verse', null: true do
      argument :tafsir_ids, String, 'Comma separated ids of tafsir to load for each verse', required: true
    end

    field :translations, [Types::TranslationType], 'translations of verse', null: true do
      argument :translation_ids, String, 'Comma separated ids of translation to load for each verse', required: true
    end

    field :audio, Types::AudioFileType, 'recitation of verse', null: true do
      argument :recitation, Integer, 'Recitation id', required: true
    end

    delegate :words, to: :object

    def translations(translation_ids:)
      object.translations
    end

    def audio(recitation:)
      object.audio_file
    end

    def tafsirs(tafsir_ids:)
      # We've already preloaded these related resources using lookahead in VerseFinder
      object.tafsirs
    end
  end
end
