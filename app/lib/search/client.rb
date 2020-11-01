# frozen_string_literal: true

module Search
  class Client
    attr_accessor :query, :options, :page

    def initialize(query, options = {})
      @query = Search::Query.new(query)
      @page = options[:page].to_i.abs
      @language = options[:language]
    end

    def search
      Search::Results.new(Verse.search(search_defination).page(@page).per(20))
    end

    protected
    def search_defination
      {
       _source: source_attributes,
       query: search_query # ,
        # highlight: highlight
      }
    end

    def search_query
      trans_query = []

      unless /[:\/]/.match(@query.query)
        available_languages = %w[ml en bs az cs fr hi es fi id it ko dv bn ku de am al fa ha mrn ms pl ja nl tr ur th
                                 no tg ug ru pt ro sq sw so sv ta uz zh tt]

        trans_query = available_languages.map { |lang| trans_query(lang, @query.query) }
      end

      words = [verse_query(@query.query), words_query(@query.query)]

      { bool: { should: trans_query + words } }
    end

    def verse_query(query)
      {
        multi_match: {
          query: query,
            fields: [
              'verse_key',
              'verse_path',
              'text_madani.text'
            ]
        }
      }
    end

    def words_query(query)
      {
        nested: {
          path: 'words',
            query: {
              multi_match: {
                query: query,
                fields: ['words.madani^2', 'words.simple']
              }
            },
            inner_hits: nested_highlight('words.madani')
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
          path: "trans_#{lang}",
            query: {
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
        fields: {
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
          fields: {
            filed => { type: 'fvh'.freeze }
          },
          tags_schema: 'styled'.freeze
        },
        size: 500
      }
    end
  end
end
