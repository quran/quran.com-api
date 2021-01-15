# frozen_string_literal: true

module Search
  class NavigationClient < Search::Client
    SOURCE_ATTRS = ['name', 'url'].freeze
    SEARCH_ATTRS = [
        "name^5",
        "url"
    ].freeze

    def initialize(query, options = {})
      super(query, options)
    end

    def search
      search = Elasticsearch::Model.search(search_defination, [Chapter, Juz])

      Search::Results.new(search, page, :navigation)
    end

    protected

    def search_defination
      {
          _source: source_attributes,
          query: search_query,
          highlight: highlight,
          from: page * VERSES_PER_PAGE,
          size: VERSES_PER_PAGE
      }
    end

    def search_query
      {
          bool: {
              should: navigational_query
          }

      }
    end

    def navigational_query
      {
          multi_match: {
              query: query.query,
              fields: SEARCH_ATTRS,
              type: "phrase"
          }
      }
    end

    def source_attributes
      SOURCE_ATTRS
    end

    def highlight
      {
          fields: {
              name: {
                  type: 'fvh',
                  fragment_size: 500
              }
          },
          tags_schema: 'styled'
      }
    end
  end
end
