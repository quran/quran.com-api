module Search
  module Query
    module Aggregations
      def aggregations
        # This will have nested results within the buckets which is great! the
        # only problem
        # there is we will have to do rails paging versus elasticsearch paging
        hash = {
          by_ayah_key: {
            terms: {
              field: 'verse_key.keyword',
              size: 6236,
              #order: {
               # average_score: 'desc'
              #}
            },
            aggs: {
              top_query_hits: {
                top_hits: {
                  sort: [
                    {
                      _score: {
                        order: 'desc'
                      }
                    }
                  ],
                  _source: '*',
                  size: 10
                }
              }
            }#,
            #aggs2: {
            #  average_score: {
            #    avg: {
            #      script: '_score'
            #    }
            #  }
            #}
          }
        }

        if false && hits_query?
          hash[:by_ayah_key][:aggs].merge!(
            match: {
              top_hits: {
                highlight: highlight,
                sort: [
                  {
                    _score: {
                      order: 'desc'
                    }
                  }
                ],
                _source: {
                  include: [
                    'text',
                    'resource.*',
                    'language.*'
                  ]
                },
                size: 3
              }
            },
            # Don't need for now.
            # max_score: {
            #   max: {
            #     script: '_score'
            #   }
            # }
          )
        end

        hash
      end
    end
  end
end
