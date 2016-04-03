module Search
  module Suggest
    class Client
      include Virtus.model

      attribute :query, Search::Query::Query

      def initialize(query, options = {})
        @lang = options[:lang]
        @size = options[:size]
        @query = Search::Query::Query.new(query)
      end

      def search_params
        {
          size: 30,
          _source_include: [ 'ayah_key', 'text' ],
          index: indices,
          body: {
            query: query_object,
            highlight: highlight
          }
        }
      end

      def response
        @response
      end

      def request
        @response = Search.client.search( search_params )

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
        indices = []
        if @query.is_arabic?
          indices.push( 'text' ) # "text" is just 6236 records of ayah text without tashkeel (mostly)
        else
          indices.push( "translation-#{@lang}" )
        end
      end

      def highlight
        {
          fields: {
            "text.autocomplete" => {
              number_of_fragments: 0, # just highlight the entire string instead of breaking it down into sentence fragments, that's easier for now
              pre_tags: [ "<b>" ],
              post_tags: [ "</b>" ],
              type: "postings"
            }
          }
        }
      end

      def query_object
        querydsl = {}
        if @query.is_arabic?
          querydsl = {
            match_phrase_prefix: {
              "text.autocomplete" => @query.query
            }
          }
        else
          querydsl = {
            match: {
              "text.autocomplete" => {
                query: @query.query,
                operator: "and"
              }
            }
          }
        end
        querydsl
      end

      def result
        result = @response

        processed = []
        seen = {}

        result['hits']['hits'].each do |hit|
          if hit.key?('highlight')
            text = hit['highlight']['text.autocomplete'][0]
          else
            text = hit['_source']['text']
          end
          ayah = "#{hit['_source']['ayah_key'].gsub(/_/,':')}"
          href = "/#{hit['_source']['ayah_key'].gsub(/_/,'/')}"
          if not seen.key?(ayah)
            seen[ayah] = true
            h = {
              #took: result['took'],
              text: text,
              href: href,
              ayah: ayah
            }
            processed.push( h )
          end
        end
        return processed[0, @size]
      end

    end
  end
end
