module Search
  module Query
    module Indices
      def index_boost
        if @query.is_arabic?
          {
            'verses' => 4
          }
        else
          if @indices_boost
            @indices_boost
          else
            {}
          end
        end
      end

      def indices
        if @query.is_arabic?
          ['verses']
        else
          ['trans*', 'verses']
        end
      end
    end
  end
end
