module Search
  module Query
    module Indices
      def index_boost
        if @query.is_arabic?
          {
            'text-font' => 4
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
          ['text-font']
        else
          ['trans*', 'text-font']
        end
      end
    end
  end
end
