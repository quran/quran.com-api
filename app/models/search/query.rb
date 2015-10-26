module Search
  class Query
    attr_accessor :page, :size, :start_time, :end_time, :delta_time, :indices_boost, :query, :ayahs, :doc_count, :response, :search_params, :errored
    attr_reader :imin, :imax, :type

    def initialize(query, options = {})
      @page = options[:page].to_i || 1
      @size = options[:size].to_i || 20
      @type = options[:type] || :aggregations # This could be either :hits or :aggregations
      @highlight = options[:highlight] || true

      @indices_boost = options[:indices_boost]
      @query = Search::QueryString.new(query)

      @prefix_length = options[:prefix_length] || 1
      @fuzziness = options[:fuzziness] || 1  # Fuzziness describes the distance from the actual word see: https://www.elastic.co/blog/found-fuzzy-search

      @content = options[:content]
      @audio = options[:audio]

      @search_params = {
        index: indices,
        type: type,
        explain: explain,
        body: {
          indices_boost: index_boost,
          highlight: highlight,
          aggregations: aggregations,
          from: from,
          size: size_query,
          # May not need this after all.
          # fields: fields,
          _source: source,
          query: query_object
        }
      }
    end

    def request
      @start_time = Time.now
      @response = Search::Request.new(@search_params, @page, @size).search
      @end_time = Time.now
      @delta_time = @end_time - @start_time

      self

    rescue

      handle_error
      self
    end

    def handle_error
      @errored = true
    end

    def errored?
      @errored
    end

    def indices
      if @query.is_arabic?
        ['text-font', 'tafsir']
      else
        ['trans*', 'text-font']
      end
    end

    def fields_val
      if @query.is_arabic?
        [
          'text^5',
          'text.lemma^4',
          'text.stem^3',
          'text.root^1.5',
          'text.lemma_clean^3',
          'text.stem_clean^2',
          'text.ngram^2',
          'text.stemmed^2'
        ]
      else
        ['text^1.6', 'text.stemmed']
      end
    end

    def index_boost
      if @query.is_arabic?
        {
          :"text-font" => 4,
          :"tafsir"    => 1
        }
      else
        if @indices_boost
          @indices_boost
        else
          {}
        end
      end
    end

    def type
      :data
    end

    def explain
      # debugging... on or off?
      false
    end

    def highlight
      if @highlight
        {
          fields: {
            text: {
              type: 'fvh',
              matched_fields: ['text.root', 'text.stem_clean', 'text.lemma_clean', 'text.stemmed', 'text'],
              ## NOTE this set of commented options highlights up to the first 100 characters only but returns the whole string
              #fragment_size: 100,
              #fragment_offset: 0,
              #no_match_size: 100,
              #number_of_fragments: 1
              number_of_fragments: 0
            }
          },
          tags_schema: 'styled',
          #force_source: true
        }
      else
        {}
      end
    end

    def aggregations
      # Aggregate and bucket results based off of Ayah Key. This is neccessary
      # as the results can come from an ayah's associated translations.
      if self.hits_query?
        {}
      else
        # This will have nested results within the buckets which is great! the only problem
        # there is we will have to do rails paging versus elasticsearch paging
        {
          by_ayah_key: {
            terms: {
              field: "ayah.ayah_key",
              size: 6236,
              order: {
                average_score: "desc"
              }
            },
            aggregations: {
              match: {
                top_hits: {
                  highlight: {
                    fields: {
                      text: {
                        type: "fvh",
                        matched_fields: [
                          "text.root",
                          "text.stem_clean",
                          "text.lemma_clean",
                          "text.stemmed",
                          "text"
                        ],
                        number_of_fragments: 0
                      }
                    },
                    tags_schema: "styled"
                  },
                  sort: [
                    {
                      _score: {
                        order: "desc"
                      }
                    }
                  ],
                  _source: {
                    include: [
                      "text",
                      "ayah.*",
                      "resource.*",
                      "language.*"
                    ]
                  },
                  size: 5
                }
              },
              max_score: {
                max: {
                  script: "_score"
                }
              },
              average_score: {
                avg: {
                  script: "_score"
                }
              }
            }
          }
        }
      end
    end

    def hits_query?
      # Could be :raw or :aggregation
      @type == :hits
    end

    def aggregations_query?
      @type == :aggregations
    end

    def size_query
      if self.hits_query?
        @size
      else
        0
      end
    end

    def from
      (@page - 1) * @size
    end

    def fields
      # This does nothing to the initial query!
      ["ayah.ayah_key", "ayah.ayah_num", "ayah.surah_id", "ayah.ayah_index", "text"]
    end

    def source
      if self.hits_query?
        ["text", "resource.*", "language.*"]
      else
        []
      end
    end

    def query_object
      query = {}

      query[:query_string] = {
        query: @query.query.force_encoding('ASCII-8BIT').force_encoding('UTF-8'),
        # default_field: "_all", We could use this for later but it adds unneeded time.
        fuzziness: 1,
        fields: fields_val,
        minimum_should_match: "85%"
      }

      query
    end
  end
end
