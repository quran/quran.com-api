# frozen_string_literal: true

require 'elasticsearch/model'

module QuranSearchable
  extend ActiveSupport::Concern

  VERSE_TEXTS_ATTRIBUTES = %i[
    text_uthmani
    text_uthmani_simple
    text_imlaei
    text_imlaei_simple
    text_indopak
  ].freeze

  included do
    include Elasticsearch::Model
    index_name 'quran_verses'

    settings YAML.safe_load(
      File.read('config/elasticsearch/settings.yml')
    )

    def verse_path
      verse_key.sub(':', '/')
    end

    def type
      'verse'
    end

    def as_indexed_json(_options = {})
      as_json(
        only: %i[
        id
        chapter_id
        verse_key
        text_uthmani
        text_uthmani_simple
        text_imlaei
        text_imlaei_simple
        text_indopak]
      )
    end

    mappings dynamic: 'false' do
      indexes :chapter_id, type: 'keyword' # Used for filters, when user want to search from specific surah

      VERSE_TEXTS_ATTRIBUTES.each do |text_type|
        indexes text_type, type: 'text' do
          indexes :text,
                  type: 'text',
                  similarity: 'my_bm25',
                  term_vector: 'with_positions_offsets_payloads',
                  analyzer: 'arabic_normalized',
                  search_analyzer: 'arabic_normalized'

          indexes :analyzed,
                  type: 'text',
                  term_vector: 'with_positions_offsets',
                  similarity: 'my_bm25'
                  #analyzer: 'arabic_synonym_normalized',
                  #search_analyzer: 'arabic_synonym_normalized'

          indexes :stemmed,
                  type: 'text',
                  similarity: 'my_bm25',
                  term_vector: 'with_positions_offsets_payloads',
                  search_analyzer: 'arabic_normalized',
                  analyzer: 'arabic_ngram'
        end
      end
    end
  end
end
