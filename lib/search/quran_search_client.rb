# frozen_string_literal: true

module Search
  class QuranSearchClient < Search::Client
    QURAN_SOURCE_ATTRS = ['verse_path', 'verse_id'].freeze

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
      results = Verse.search(search_defination)

      # For debugging, copy the query and paste in kibana for debugging
      # File.open("_last_query.json", "wb") do |f|
      #  f << search_defination.to_json
      # end

      if results.empty?
        Search::NavigationClient.new(query.query).search
      else
        Search::Results.new(results, page)
      end
    end

    def suggest
      results = Verse.search(search_defination(100, 10))

      # For debugging, copy the query and paste in kibana for debugging
      #File.open("last_suggest_query.json", "wb") do |f|
      #  f << search_defination.to_json
      #end

      if results.empty?
        Search::NavigationClient.new(query.query).search
      else
        Search::Results.new(results, page)
      end
    end

    protected

    def search_defination(highlight_size = 500, result_size = VERSES_PER_PAGE)
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
        {_score: {order: :desc}}
      ]
    end

    def search_query(highlight_size = 500)
      match_any = [
        nested_translation_query('default', highlight_size)
      ]

      get_detected_languages_code.each do |lang|
        match_any << nested_translation_query(lang, highlight_size)
      end

      match_any << quran_text_query
      # match_any += words_query

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
                fields: ['text_uthmani_simple.*^10', 'text_uthmani.*^10', 'text_imlaei.*^10', 'verse_key.keyword^10', 'verse_path^5'],
                type: "phrase"
              }

              # disable this if we need exact match
              #multi_match: {
              #  query: query.query,
              #  fields: QURAN_SEARCH_ATTRS
              #}
            }
          ]
        }
      }
    end

    def nested_translation_query(language_code, highlight_size)
      matches = [
        {
          "multi_match": {
            "query": query.query,
            "fields": ["trans_#{language_code}.text.*^5"],
            type: "phrase"
          }
        }
      ]

      if !phrase_matching
        matches << {
          "multi_match": {
            "query": query.query,
            "fields": ["trans_#{language_code}.text.*^1"],
          }
        }
      end

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
          }
        },
        tags_schema: 'styled'
      }
    end

    def filters
      query_filters = {}

      if filter_chapter?
        query_filters[:match_phrase] = {chapter_id: options[:chapter].to_i}
      end

      [query_filters.presence].compact
    end

    def filter_chapter?
      options[:chapter].presence && options[:chapter].to_i > 0
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
        QuranSearchable::TRANSLATION_LANGUAGE_CODES.include?(lang)
      end.presence || ['en']
    end
  end
end
