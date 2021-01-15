# frozen_string_literal: true

module Search
  class Suggest
    attr_accessor :query, :lang, :size

    def initialize(query, lang: 'en', size: 10)
      @query = Search::Query.new(query)
      @lang  = lang
      @size  = size
    end

    def get_suggestions
      process_results Verse.search(search_defination).page(1).per(10)
    end

    protected
    def search_defination
      {
        _source:   source_attributes,
        query:     suggest_query,
        highlight: highlight
      }
    end

    def suggest_query
      trans_query = []

      unless /[:\/]/.match(@query.query)
        available_languages = %w[ml en bs az cs fr hi es fi id it ko dv bn ku de am al fa ha mrn ms pl ja nl tr ur th
                                 no tg ug ru pt ro sq sw so sv ta uz zh tt]

        trans_query = available_languages.map { |lang| trans_query(lang, @query.query) }
      end

      _verse_query = [verse_query(@query.query)]

      { bool: { should: _verse_query + trans_query } }
    end

    def verse_query(query)
      {
        multi_match: {
          query:  query,
          fields: [
                    'verse_key',
                    'verse_path',
                    'text_madani.text',
                    'text_simple.text',
                    'text_indopak.text',
                    'chapter_names'
                  ]
        }
      }
    end

    def trans_query(lang, query)
      # We boost the results if the query matched a translation of the same language as the user requested
      lang_boost = 1
      if lang == @language
        lang_boost = 2
      end

      {
        nested: {
          path:       "trans_#{lang}",
          query:      {
            match: {
              "trans_#{lang}.text": {
                query: query,
                boost: lang_boost
              }
            }
          },
          inner_hits: nested_highlight("trans_#{lang}.text")
        }
      }
    end

    def source_attributes
      ['verse_key', 'id']
    end

    def highlight
      {
        fields:      {
          'text_madani.text' => {
            type: 'fvh'.freeze
          }
        },
        tags_schema: 'styled'.freeze
      }
    end

    def nested_highlight(filed)
      {
        highlight: {
          fields:              {
            filed => { type: 'plain'.freeze },
          },
          tags_schema:         'styled'.freeze,
          number_of_fragments: 1, # Don't highlight entire translation
          fragment_size:       90, # return 90 chars around matched word
          pre_tags:            ['<b>'],
          post_tags:           ['</b>']
        }
      }
    end

    def process_results(es_response)
      processed = []

      results = es_response.results.results

      results.map do |hit|
        matched_values = if hit['highlight'].present?
          [hit['highlight']['text_madani.text'].first]
        else
          trans = hit['inner_hits'].detect do |key, value|
            value['hits']['total'] > 0
          end

          next unless trans
          trans.last['hits']['hits'].map do |trans_match|
            text = trans_match['highlight'].first.last.last
            translation_id = trans_match['_source']['resource_content_id']

            [text, translation_id]
          end
        end

        verse_key = "#{hit['_source']['verse_key']}"
        href      = "/#{verse_key.tr ':', '/'}"

        matched_values.each do |match|
          processed << {
            text: match.is_a?(Array) ? match[0] : match,
            href: match.is_a?(Array) ? "#{href}?translations=#{match[1]}" : href,
            ayah: verse_key
          }
        end
      end

      processed
    end
  end
end
