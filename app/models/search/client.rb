module Search
  module Query
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
      attribute :fuzziness, Integer, default: 1, lazy: true

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
        {
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
      end

      def request
        @start_time = Time.now
        # binding.pry
        @ayah_keys = Search::Request.new(search_params, @type).search.keys
        @total = @ayah_keys.length
        @type = :hits
        @response = Search::Request.new(search_params, @type).search
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

      def explain
        # debugging... on or off?
        false
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
            'ayah.ayah_key' => Kaminari.paginate_array(@ayah_keys).page(@page).per(@size)
          }
        }
      end

      def simple_query_string
        {
          simple_query_string: {
            query: @query.query,
            # default_field: "_all",
            # lenient: true,
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
            minimum_should_match: '<65%'
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
              multi_match
            ],
            should: [
              multi_match('phrase'),
              simple_query_string
            ]
          }
        }

        bool[:must].unshift(terms) if hits_query?

        bool
      end

      def dis_max_query
        {
          dis_max: {
            tie_breaker: 0.7,
            boost: 1,
            queries: [
              query_string,
              multi_match,
              multi_match('phrase')
            ]
          }
        }
      end

      def query_object
        query = bool_query
        query
      end

      def suggest
        # {
        #   text: @query.query,
        #   "simple_phrase": {
        #     "phrase": {
        #       "field": "text",
        #       "size": 5,
        #       "real_word_error_likelihood": 0.95,
        #       "max_errors": 0.5,
        #       "gram_size": 2,
        #       "direct_generator": [
        #         {
        #           "field": "text",
        #           "suggest_mode": "always",
        #           "min_word_length": 1
        #         }
        #       ],
        #       "highlight": {
        #         "pre_tag": "<em>",
        #         "post_tag": "</em>"
        #       }
        #     }
        #   }
        # }
      end
    end
  end
end
