# How search works:
# Currently, two calls are being made to ES since we are using their aggregations query.
# 1. Makes a call to fetch the ayahs that match the query. This is very fast and lightweight. After
# we get the keys, we then paginate on the Rails level and make 2. query to fetch the data.
# after data is returned, we query it against our database to return to the frontend. Hence why there are
# two type calls, one is :aggregations (the ayah one) and :hits (getting the actual results).
module Search
  class Client
    TYPE_HITS = :hits
    TYPE_AGGREGATIONS = :aggregations

    include Search::Query::Aggregations
    include Search::Query::Highlight
    include Search::Query::Fields
    include Search::Query::Indices

    include Virtus.model

    attribute :page, Integer, default: 1
    attribute :size, Integer, default: 20
    attribute :start_time, Time
    attribute :end_time, Time
    attribute :delta_time, Float
    attribute :indices_boost, Hash
    attribute :query, Search::Query::Query

    # Computed
    attribute :total, Integer
    attribute :response, Search::Results
    attribute :ayah_keys, Array
    attribute :type, Symbol, default: TYPE_AGGREGATIONS, lazy: true

    # Options
    # attribute :highlight, Boolean, default: true
    # # Fuzziness describes the distance from the actual word
    # see: https://www.elastic.co/blog/found-fuzzy-search
    attribute :fuzzy_prefix_length, Integer, default: 0, lazy: true
    attribute :fuzziness, Integer, default: 'AUTO', lazy: true

    def initialize(query, options = {})
      @page = options[:page].to_i
      @size = options[:size].to_i
      @type = options[:type]

      @indices_boost = options[:indices_boost]
      @query = Search::Query::Query.new(query)

      @content = options[:content]
      @audio = options[:audio]
    end

    def search_params
      params = {
        index: indices,
        type: :data,
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

      params[:body].merge!(highlight: highlight) if hits_query?

      params
    end

    def request
      @start_time = Time.now
      # This call goes and fetches the ayahs, then we just want their keys.
      @ayah_keys = Search::Request.new(search_params, @type).search.keys

      @total = @ayah_keys.length
      @type = TYPE_HITS

      # Fetches the actual results.
      @response = Search::Request.new(search_params, @type).search
      @end_time = Time.now
      @delta_time = @end_time - @start_time

      self

    rescue

      @errored = true
      self
    end

    def errored?
      @errored
    end

    def explain
      # debugging... on or off?
      false
    end

    def hits_query?
      @type == TYPE_HITS
    end

    def aggregations_query?
      @type == TYPE_AGGREGATIONS
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

    def source
      if self.hits_query?
        ['text', 'resource.*', 'language.*']
      else
        []
      end
    end

    def terms
      {
        terms: {
          # Ayah keys go here, make sure they are underscored like 1_2
          'ayah_key' => Kaminari.paginate_array(@ayah_keys).page(@page).per(@size)
        }
      }
    end

    def simple_query_string
      {
        simple_query_string: {
          query: @query.query,
          # default_field: "_all",
          lenient: true,
          fields: fields_val,
          minimum_should_match: '85%'
        }
      }
    end

    def query_string
      {
        query_string: {
          query: "#{@query.query}~",
          #  We could use this for later but it adds unneeded time.
          # default_field: "_all",
          auto_generate_phrase_queries: true,
          lenient: true,
          fields: fields_val,
          fuzziness: fuzziness,
          phrase_slop: 100,
          minimum_should_match: '95%'
        }
      }
    end

    def multi_match(type = 'most_fields')
      {
        multi_match: {
          type: type,
          slop: 50,
          query: @query.query,
          fields: fields_val,
          fuzziness: fuzziness,
          minimum_should_match: '65%'
        }
      }
    end

    def match
      {
        match: {
          text: {
            query: @query.query,
            fuzziness: fuzziness
          }
        }
      }
    end

    def bool_query
      bool = {
        bool: {
          must: [
            dis_max_query
          ]
        }
      }

      bool[:bool][:filter] = terms if hits_query?

      bool
    end

    def dis_max_query
      {
        dis_max: {
          tie_breaker: 0.7,
          boost: 1,
          queries: [
            simple_query_string,
            multi_match,
            multi_match('phrase')
          ]
        }
      }
    end

    def query_object
      bool_query
      # This is the best query as it's a union of all the queries! But we need to
      # figure out how to get the TYPE_HITS query to behave nicely.
      # dis_max_query
    end
  end
end
