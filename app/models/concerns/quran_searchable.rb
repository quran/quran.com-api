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
    text_qpc_hafs
  ].freeze

  included do
    include Elasticsearch::Model
    index_name 'quran_verses'

    settings YAML.safe_load(
      File.read('config/elasticsearch/settings.yml')
    )

    def type
      'verse'
    end

    def as_indexed_json(_options = {})
      hash = as_json(
        only: %i[
        id
        chapter_id
        verse_key
        words_count
        text_uthmani
        text_uthmani_simple
        text_imlaei
        text_imlaei_simple
        text_qpc_hafs
        text_indopak],
        methods: [:verse_id]
      )

      hash[:words] = char_words.map do |w|
        {
          id: w.id,
          text_uthmani: w.text_uthmani,
          text_uthmani_simple: w.text_uthmani_simple,
          text_imlaei: w.text_imlaei,
          text_imlaei_simple: w.text_imlaei_simple,
          text_indopak: w.text_indopak,
          text_qpc_hafs: w.text_qpc_hafs
        }
      end

      hash
    end

    mappings dynamic: 'false' do
      indexes :chapter_id, type: 'keyword' # Used for filters, when user want to search from specific surah
      indexes :words_count, type: 'integer' # Used for sorting ayah, short ayahs came first in the result

      indexes :words, type: 'nested', include_in_parent: true do
        indexes :text_uthmani,
                type: 'text',
                term_vector: 'with_positions_offsets',
                analyzer: 'arabic_normalized',
                similarity: 'my_bm25'

        indexes :text_uthmani_simple,
                type: 'text',
                term_vector: 'with_positions_offsets',
                analyzer: 'arabic_normalized',
                similarity: 'my_bm25'

        indexes :text_imlaei,
                type: 'text',
                term_vector: 'with_positions_offsets',
                analyzer: 'arabic_normalized',
                similarity: 'my_bm25'

        indexes :text_imlaei_simple,
                type: 'text',
                term_vector: 'with_positions_offsets',
                analyzer: 'arabic_normalized',
                similarity: 'my_bm25'

        indexes :text_indopak,
                type: 'text',
                term_vector: 'with_positions_offsets',
                analyzer: 'arabic_normalized',
                similarity: 'my_bm25'

        indexes :text_qpc_hafs,
                type: 'text',
                term_vector: 'with_positions_offsets',
                analyzer: 'arabic_normalized',
                similarity: 'my_bm25'
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
                  similarity: 'my_bm25'

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
