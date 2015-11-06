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
              field: 'ayah.ayah_key',
              size: 6236,
              order: {
                average_score: 'desc'
              }
            },
            aggregations: {
              average_score: {
                avg: {
                  script: '_score'
                }
              }
            }
          }
        }

        if hits_query?
          hash[:by_ayah_key][:aggregations].merge!(
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
                    'ayah.*',
                    'resource.*',
                    'language.*'
                  ]
                },
                size: 5
              }
            },
            # Don't need for now.
            max_score: {
              max: {
                script: '_score'
              }
            }
          )
        end

        hash
      end
    end
  end
end
