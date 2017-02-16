module Search
  module Query
    module Highlight
      def highlight
        {
          fields: {
            text: {
              type: 'fvh',
              matched_fields: ['verses.text_madani', 'verses.stemmed'],
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
      end
    end
  end
end
