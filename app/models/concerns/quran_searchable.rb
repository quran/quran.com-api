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
    text_indopak_simple
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
        verse_key
        chapter_id
        text_uthmani
        text_uthmani_simple
        text_imlaei
        text_imlaei_simple
        text_indopak
        text_indopak_simple
    ],
        methods: %i[verse_path verse_id type]
      )
    end

    mappings dynamic: 'false' do
      indexes :verse_path, type: 'keyword' # allow user to search by path e.g 1/2, 2/29 etc
      indexes :chapter_id, type: 'keyword' # Used for filters, when user want to search from specific surah
      indexes :verse_id, type: 'integer' # For loading record from db. We're not using ES's records method. All indexes will have this field
      indexes :verse_key, type: 'text' do
        indexes :keyword, type: 'keyword'
      end

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
                  analyzer: 'arabic_synonym_normalized',
                  similarity: 'my_bm25',
                  search_analyzer: 'arabic_synonym_normalized'

          indexes :stemmed,
                  type: 'text',
                  similarity: 'my_bm25',
                  term_vector: 'with_positions_offsets',
                  search_analyzer: 'arabic_stemmed',
                  analyzer: 'arabic_ngram'
        end
      end
    end
  end
end
