# frozen_string_literal: true
module Qdc
  module Search
    class QuranSearchClient < Search::Client
      TRANSLATION_LANGUAGES = Language.with_translations
      TRANSLATION_LANGUAGE_CODES = TRANSLATION_LANGUAGES.pluck(:iso_code)

      QURAN_SOURCE_ATTRS = [
        'verse_path',
        'verse_key',
        'verse_id',
        'type',
        'resource_id',
        'language_id',
        'resource_name',
        'language_name'
      ].freeze

      QURAN_SEARCH_ATTRS = [
        # Uthmani
        "text_uthmani_simple.*^4",
        "text_uthmani.*^3",

        # Imlaei script
        "text_imlaei*^4",
        "text_imlaei_simple.*^2",

        # Indopak script
        "text_indopak",
        "text_indopak_simple",

        "verse_key.keyword",
        "verse_path"
      ].freeze

      def initialize(query, options = {})
        super(query, options)
      end

      def search
        # TODO: search from relevant indexes
        search = Elasticsearch::Model.search(search_definition, [], index: 'quran_verses,quran_content_*')

        # For debugging, copy the query and paste in kibana for debugging
        #File.open("last_query.json", "wb") do |f|
        #  f << search_definition.to_json
        #end

        Search::Results.new(search, page)
      end

      def suggest
        search = Elasticsearch::Model.search(search_definition(100, 10), [], index: 'quran_verses,quran_content_*')

        # For debugging, copy the query and paste in kibana for debugging
        #File.open("last_suggest_query.json", "wb") do |f|
        #  f << search_definition(100, 10).to_json
        #end

        Search::Results.new(search, page)
      end

      protected

      def search_definition(highlight_size = 500, result_size = VERSES_PER_PAGE)
        {
          _source: source_attributes,
          query: search_query,
          highlight: highlight(highlight_size),
          from: page * result_size,
          size: result_size,
          sort: sort_results
        }
      end

      def sort_results
        [
          { _score: { order: :desc } }
        ]
      end

      def search_query(highlight_size = 500)
        match_any = match_any_queries

        match_any << quran_text_query

        #get_detected_languages_code.each do |lang|
        #  match_any << translation_query(lang)
        #end

        {
          bool: {
            should: match_any,
            filter: filters
          }
        }
      end

      def words_query
        [
          {
            nested: {
              path: 'words',
              query: {
                multi_match: {
                  query: query.query.remove_dialectic,
                  fields: ['words.text_uthmani_simple.*'],
                  type: "phrase"
                }
              }
            }
          },
          {
            nested: {
              path: 'words',
              query: {
                multi_match: {
                  query: query.query,
                  fields: ['words.text_uthmani.*', 'words.text_imlaei.*']
                }
              }
            }
          }
        ]
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
                    'text_uthmani_simple.*',
                    'text_uthmani.*',
                    'text_imlaei.*',
                    'verse_key.keyword^2',
                    'verse_path.keyword'
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
      def simple_match_query(fields: ['*'])
        {
          "simple_query_string": {
            "query": query.query,
            "fields": fields
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
          multi_match_query(fields: [
            "text.autocomplete",
            "text.autocomplete._2gram",
            "text.autocomplete._3gram"
          ]),
          simple_match_query,
          match_phrase_prefix_query
        ]
      end

      def nested_translation_query(language_code, highlight_size)
        matches = simple_match_query(fields: ["trans_#{language_code}.text.*"])

        {
          nested: {
            path: "trans_#{language_code}",
            score_mode: "max",
            query: {
              bool: {
                should: matches,
                minimum_should_match: '75%'
              }
            },
            inner_hits: {
              _source: ["*.resource_name", "*.resource_id", "*.language"],
              highlight: {
                tags_schema: 'styled',
                fields: {
                  "trans_#{language_code}.text.text": {
                    fragment_size: highlight_size
                  }
                }
              }
            }
          }
        }
      end

      def source_attributes
        QURAN_SOURCE_ATTRS
      end

      def highlight(highlight_size = 500)
        {
          fields: {
            "text_uthmani.*": {
              type: 'fvh',
              fragment_size: highlight_size
            },
            "text.autocomplete": {

            }
          },
          tags_schema: 'styled'
        }
      end

      def filters
        query_filters = []

        if filter_chapter?
          query_filters.push(term: { chapter_id: options[:chapter].to_i })
        end

        if filter_translation?
          query_filters.push(term: { resource_id: options[:translation].to_i })
        end

        if filter_language?
          query_filters.push(term: { language_id: options[:language].id })
        end

        query_filters
      end

      def filter_chapter?
        options[:chapter].presence && options[:chapter].to_i > 0
      end

      def filter_translation?
        options[:translation].presence && options[:translation].to_i > 0
      end

      def filter_language?
        options[:language]
      end

      def get_detected_languages_code
        # CLD language detection has some flaws, sometime will detect Assamee language as Bangla, Urdu as Farsi
        # Solution here is, if CLD is detected Fari from query, we'll search from Urdu documents as well

        detected_languages = query.detect_languages
        related_language = Language.where(iso_code: detected_languages).pluck(:es_indexes)

        if detected_languages == ['ar']
          languages = detected_languages
        else
          languages = (detected_languages + related_language).flatten.uniq
        end

        languages.select do |lang|
          TRANSLATION_LANGUAGE_CODES.include?(lang)
        end.presence || ['en']
      end
    end
  end
end