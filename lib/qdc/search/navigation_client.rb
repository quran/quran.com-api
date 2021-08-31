# frozen_string_literal: true

module Qdc
  module Search
    class NavigationClient < Qdc::Search::Client
      SOURCE_ATTRS = %w[key name result_type priority].freeze
      RESULT_SIZE = 30
      PREFIX_SLOP = 1

      def initialize(query, options = {})
        super(query, options)
      end

      def search
        response = Elasticsearch::Model.search(search_definition, [Chapter], index: Chapter.index_name)

        # For debugging, copy the query and paste in kibana for debugging
        if DEBUG_ES_QUERIES
          File.open("es_queries/last_navigational_query.json", "wb") do |f|
            f << search_definition.to_json
          end
        end

        Search::NavigationalResults.new(response)
      end

      protected

      def search_definition
        {
          _source: source_attributes,
          query: search_query,
          size: RESULT_SIZE,
          collapse: { # get uniq results for each navigation record type.
            field: 'result_type'
          },
          sort: sort_query
        }
      end

      def search_query
        {
          bool: {
            should: [
              match_phrase_query, # First preference to exact match
              match_phrase_prefix_query # Then prefix match, this will allow us searching with partial keyword like **cav**, **baq**
            ]
          }
        }
      end

      def match_phrase_prefix_query
        {
          match_phrase_prefix: {
            text: {
              query: query.query,
              slop: PREFIX_SLOP
            }
          }
        }
      end

      def match_phrase_query
        {
          match_phrase: {
            text: {
              query: query.query,
              slop: PREFIX_SLOP
            }
          }
        }
      end

      def sort_query
        [
          {
            priority: {
              order: 'asc'
            }
          }
        ]
      end

      def source_attributes
        SOURCE_ATTRS
      end
    end
  end
end
