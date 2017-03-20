module Search
  class Client
    attr_accessor :query, :options, :page

    def initialize(query, options={})
      @query = Search::Query.new(query)
      @page = options[:page].to_i.abs
      @language = options[:language]
    end

    def search
      Search::Results.new(Verse.search(search_defination).page(@page))
    end

    protected
    def search_defination
      {
       _source: source_attributes,
       query: search_query,
       highlight: highlight
      }
    end

    def search_query
      #hash = if @query.is_arabic?
      #         [verse_query(@query.query), words_query(@query.query)]
      #       else
      #         ids = Translation.where(resource_type: 'Verse').pluck(:language_id).uniq
      #         available_languages = Language.find(ids).pluck(:iso_code)
      #         available_languages.map {|lang| trans_query(lang, @query.query)}
      #       end
      #ids = Translation.where(resource_type: 'Verse').pluck(:language_id).uniq.first(10)
      #available_languages = Language.find(ids).pluck(:iso_code)

      available_languages = [ "ml", "en", "bs", "az", "cs", "fr", "hi", "es", "fi", "id", "it", "ko", "dv", "bn", "ku",
                               "de", "am", "al", "fa", "ha", "mrn", "ms", "pl", "ja", "nl", "tr", "ur", "th", "no", "tg",
                               "ug", "ru", "pt", "ro", "sq", "sw", "so", "sv", "ta", "uz", "zh", "tt"
                            ]

      trans = available_languages.map {|lang| trans_query(lang, @query.query)}
      words = [verse_query(@query.query), words_query(@query.query)]

      {bool: {should: trans + words }}
    end

    def verse_query(query)
      {
        multi_match: {
          query: query,
            fields: [
              'verse_key',
              'chapter_names',
              'transliterations',
              'text_madani.text',
              'text_madani.simple',
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
                fields: ["words.madani^2", "words.simple"]
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

      return {
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
      ["verse_key", "id"]
    end

    def highlight
      {
        fields: {
          transliterations: {
            type: 'fvh'.freeze
          },
          "text_madani.text"  => {
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
        }
      }
    end
  end
end
