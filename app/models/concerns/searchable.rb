# vim: ts=4 sw=4 expandtab
module Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model

    settings YAML.load(
        File.read(
            File.expand_path(
                "#{Rails.root}/config/elasticsearch/settings.yml", __FILE__
            )
        )
    )

    # Initial the paging gem, Kaminari
    Kaminari::Hooks.init
    Elasticsearch::Model::Response::Response.__send__ :include, Elasticsearch::Model::Response::Pagination::Kaminari

    def chapter_names
      names = [chapter.name_arabic, chapter.name_complex, chapter.name_simple]
      names + chapter.translated_names.pluck(:name)
    end

    def as_indexed_json(options={})
      hash = self.as_json(
          only: [:id, :verse_key, :text_madani, :text_indopak, :text_simple],
          methods: :chapter_names
      )

      hash[:transliterations] = transliterations.first.try(:text)

      translations.includes(:language).each do |trans|
        hash["trasn_#{trans.language.iso_code}"] ||= []
        hash["trasn_#{trans.language.iso_code}"] << {text: trans.text, author: trans.resource_content.author_name }
      end

      hash
    end

    index_name 'verses'

    mapping do
      #TODO: add words in mapping for highlighting
      indexes :id, type: 'integer'

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

      indexes :verse_key, type: 'text' do
        indexes :keyword, type: 'keyword'
      end

      indexes :chapter_names
      indexes :transliterations

      languages = Translation.where(resource_type: 'Verse').pluck(:language_id).uniq
      available_languages = Language.where(id: languages)
      available_languages.each do |lang|
        es_analyzer = lang.es_analyzer_default.present? ? lang.es_analyzer_default : nil

        indexes "trasn_#{lang.iso_code}", type: 'nested' do
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
        end
      end
    end
  end
end
