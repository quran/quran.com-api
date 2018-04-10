# frozen_string_literal: true

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
    # Kaminari::Hooks.init
    Elasticsearch::Model::Response::Response.__send__ :include, Elasticsearch::Model::Response::Pagination::Kaminari

    def chapter_names
      names = [chapter.name_arabic, chapter.name_complex, chapter.name_simple]
      names + chapter.translated_names.pluck(:name)
    end

    def verse_path
      "#{chapter_id}/#{verse_number}"
    end

    def as_indexed_json(options = {})
      hash = self.as_json(
        only: [:id, :verse_key, :text_madani, :text_indopak, :text_simple],
        methods: [:verse_path, :chapter_names]
      )

      hash[:words] = words.where.not(text_madani: nil).map do |w|
        { id: w.id, madani: w.text_madani, simple: w.text_simple }
      end

      translations.includes(:language).each do |trans|
        hash["trans_#{trans.language.iso_code}"] ||= []
        hash["trans_#{trans.language.iso_code}"] << { id: trans.id,
                                                     text: trans.text,
                                                     author: trans.resource_content.author_name,
                                                     language_name: trans.language_name.downcase,
                                                     resource_content_id: trans.resource_content_id
        }
      end

      hash
    end

    index_name 'verses'

    mapping do
      indexes :id, type: 'integer'

      [:text_madani, :text_indopak, :text_simple].each do |text_type|
        indexes text_type, type: 'text' do
          indexes :text,
                  type: 'text',
                  similarity: 'my_bm25',
                  term_vector: 'with_positions_offsets',
                  analyzer: 'arabic_normalized'
          # indexes :stemmed,
          #         type: 'text',
          #         similarity: 'my_bm25',
          #         term_vector: 'with_positions_offsets',
          #         search_analyzer: 'arabic_normalized',
          #         analyzer: 'arabic_ngram'
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

      indexes :verse_path, type: 'keyword' # allow user to search by path e.g 1/2, 2/29 etc

      indexes :chapter_names
      indexes 'words', type: 'nested' do
        indexes :madani,
                type: 'text',
                term_vector: 'with_positions_offsets',
                analyzer: 'arabic_normalized',
                similarity: 'my_bm25'
        indexes :simple,
                type: 'text',
                term_vector: 'with_positions_offsets',
                analyzer: 'arabic_normalized',
                similarity: 'my_bm25'
      end

      languages = Translation.where(resource_type: 'Verse').pluck(:language_id).uniq
      available_languages = Language.where(id: languages)
      available_languages.each do |lang|
        es_analyzer = lang.es_analyzer_default.present? ? lang.es_analyzer_default : nil

        indexes "trans_#{lang.iso_code}", type: 'nested' do
          indexes :text,
                  type: 'text',
                  similarity: 'my_bm25',
                  term_vector: 'with_positions_offsets',
                  analyzer: es_analyzer || 'standard'
          #   indexes :stemmed,
          #           type: 'text',
          #           similarity: 'my_bm25',
          #           term_vector: 'with_positions_offsets_payloads',
          #           analyzer: es_analyzer || 'english'
          # end
        end
      end
    end
  end
end
