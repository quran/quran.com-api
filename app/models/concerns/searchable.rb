# vim: ts=4 sw=4 expandtab
module Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model

    index_name 'quran.text'

    settings YAML.load(
        File.read(
            File.expand_path(
                "#{Rails.root}/config/elasticsearch/settings.yml", __FILE__
            )
        )
    )

    mapping dynamic: 'false' do
      indexes :id, type: 'integer', index: 'no'

      [:text_madani, :text_indopak, :text_simple].each do |text_type|
        indexes text_type, type: 'text' do
          indexes :text,
                  type: 'text',
                  similarity: 'my_bm25',
                  term_vector: 'with_positions_offsets_payloads',
                  analyzer: 'arabic_normalized'
          indexes :stemmed,
                  type: 'text',
                  similarity: 'my_bm25',
                  term_vector: 'with_positions_offsets_payloads',
                  search_analyzer: 'arabic_normalized',
                  analyzer: 'arabic_ngram'
          indexes :autocomplete,
                  type: 'string',
                  analyzer: 'autocomplete_arabic',
                  search_analyzer: 'arabic_normalized',
                  index_options: 'offsets'
        end
      end

      indexes :verse_key
      indexes :chapter_name

      indexes :translations, type: 'nested' do
        languages = Translation.where(resource_type: 'Verse').pluck(:language_id).uniq
        available_languages = Language.where(id: languages)

        available_languages.each do |lang|
          es_analyzer = lang.es_analyzer_default.present? ? lang.es_analyzer_default : nil

          indexes "trasn_#{lang.iso_code}", type: 'text' do
            indexes :text,
                    type: 'text',
                    similarity: 'my_bm25',
                    term_vector: 'with_positions_offsets_payloads',
                    analyzer: es_analyzer || 'standard'
            indexes :stemmed,
                    type: 'text',
                    similarity: 'my_bm25',
                    term_vector: 'with_positions_offsets_payloads',
                    analyzer: es_analyzer || 'english'
            indexes :shingles,
                    type: 'text',
                    similarity: 'my_bm25',
                    term_vector: 'with_positions_offsets_payloads',
                    analyzer: 'shingle_analyzer'
            indexes :autocomplete,
                    type: 'text',
                    analyzer: 'autocomplete',
                    search_analyzer: 'standard',
                    index_options: 'offsets'
          end
        end
      end
    end

    # Initial the paging gem, Kaminari
    Kaminari::Hooks.init
    Elasticsearch::Model::Response::Response.__send__ :include, Elasticsearch::Model::Response::Pagination::Kaminari
  end
end
