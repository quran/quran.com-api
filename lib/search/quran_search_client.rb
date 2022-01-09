# frozen_string_literal: true
module Search
  class QuranSearchClient < Search::Client
    TRANSLATION_LANGUAGES = Language.with_translations
    TRANSLATION_LANGUAGE_CODES = TRANSLATION_LANGUAGES.pluck(:iso_code)
    DEFAULT_TRANSLATION = [131, 20]

    QURAN_SOURCE_ATTRS = [
      'language_id',
      'language_name',
      'resource_id',
      'resource_name',
      'verse_id',
      'verse_key'
    ].freeze

    def initialize(query, options = {})
      super(query, options)
    end

    def search
      indexes = indexes_for_search
      search = Elasticsearch::Model.search(search_definition, [], index: indexes)

      # For debugging, copy the query and paste in kibana for debugging
      if DEBUG_ES_QUERIES
        File.open("es_queries/v3_last_query.json", "wb") do |f|
          f << "indexes: #{indexes} "
          f << search_definition.to_json
        end
      end

      Search::Results.new(search, page, result_size)
    end

    protected

    def search_definition(highlight_size = 500)
      {
        _source: source_attributes,
        query: search_query,
        highlight: {
          fields: {
            text: {
              number_of_fragments: 0,
              type: 'plain'
            },
            "text_qpc_hafs.text": {
              number_of_fragments: 0,
              type: 'plain'
            },
            "text_uthmani.text": {
              number_of_fragments: 0,
              type: 'plain'
            }
          }
        },
        from: page * result_size,
        size: result_size,
        sort: sort_results
      }
    end

    def sort_results
      [
        { _score: { order: :desc } },
        { _id: { order: :asc } }
      ]
    end

    def search_query(highlight_size = 500)
      match_any = match_any_queries
      match_any << words_query
      match_any << translation_query

      {
        bool: {
          should: match_any
        }
      }
    end

    def words_query
      {
        nested: {
          path: 'words',
          ignore_unmapped: true,
          query: {
            multi_match: {
              tie_breaker: 0.3,
              type: 'best_fields',
              query: query.query,
              fields: ['words.*']
            }
          },
          inner_hits: {
            _source: ["words.id", "words.text_qpc_hafs"]
          }
        }
      }
    end

    def quran_text_query
      {
        bool: {
          should: [
            {
              multi_match: {
                query: query.query,
                boost: 5,
                fields: [
                  'text_*.*',
                ],
                type: "phrase"
              }
            }
          ]
        }
      }
    end

    #
    # https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-simple-query-string-query.html
    #
    def simple_match_query(fields: ['*'], op: 'OR')
      {
        simple_query_string: {
          query: query.query,
          fields: fields,
          default_operator: 'OR'
        }
      }
    end

    def match_phrase_prefix_query(fields: '*')
      {
        match_phrase_prefix: {
          fields => query.query
        }
      }
    end

    def multi_match_query(type: 'best_fields', fields: ['*'])
      {
        multi_match: {
          query: query.query,
          type: type,
          fields: fields
        }
      }
    end

    def match_any_queries
      [
=begin
          multi_match_query(fields: [
            "*.autocomplete",
            "*.autocomplete._2gram",
            "*.autocomplete._3gram"
          ]),
=end
        simple_match_query(
          fields: [
            'text_uthmani.*',
            'text_uthmani_simple.*',
            'text_imlaei.*',
            'text_imlaei_simple.*',
            'text_indopak.*',
            'text_qpc_hafs.*'
          ]
        )
      ]
    end

    def translation_query
      query = simple_match_query(
        fields: ["text"],
        op: 'AND'
      )

      {
        bool: {
          must: query,
          filter: filters
        }
      }
    end

    def source_attributes
      QURAN_SOURCE_ATTRS
    end

    def filters
      query_filters = []

      if filter_chapter?
        query_filters.push(term: { chapter_id: options[:chapter].to_i })
      end

      if filter_language?
        query_filters.push(terms: { language_id: [filter_language.id] })
      end

      if filter_translations?
        query_filters.push(terms: { resource_id: filter_translations })
      end

      query_filters
    end

    def filter_chapter?
      options[:chapter].presence && options[:chapter].to_i > 0
    end

    def filter_translations?
      filter_translations.present?
    end

    def filter_translations
      options[:translations].presence
    end

    def filter_language?
      filter_language.present?
    end

    def filter_language
      strong_memoize :filter_lang do
        if options[:language].present?
          Language.find_with_id_or_iso_code(options[:language])
        end
      end
    end

    def get_detected_languages_code
      # CLD language detection has some flaws, sometime will detect Assamee language as Bangla, Urdu as Farsi
      # Solution here is, if CLD is detected Fari from query, we'll search from Urdu documents as well
      detected_languages = query.detect_languages
      related_language = Language.where(iso_code: detected_languages).pluck(:es_indexes)

      if query.only_arabic?
        languages = detected_languages.flatten.uniq
      else
        languages = (detected_languages + related_language).flatten.uniq
      end

      languages.select do |lang|
        TRANSLATION_LANGUAGE_CODES.include?(lang)
      end.presence || []
    end

    def indexes_for_search
      indexes = ['quran_verses']

      if filter_language?
        indexes << "quran_#{filter_language.iso_code}"
      else
        detected_langs = (get_detected_languages_code + ['en']).uniq

        detected_langs.each do |code|
          indexes << "quran_#{code}"
        end
      end

      indexes
    end
  end
end
