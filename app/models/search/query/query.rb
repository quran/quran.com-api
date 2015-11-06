module Search
  module Query
    class Query
      include Virtus.model

      attribute :query, String

      def initialize(query)
        to_escape = %w_+ - = & | > < ! ( ) { } [ ] ^ " ~ * ? : \ /_
        re = Regexp.union(to_escape)

        @query = query.force_encoding('ASCII-8BIT').force_encoding('UTF-8').gsub(re) { |m| "\\#{m}" }
      end

      def language_match
        @query.prose
      end

      def is_arabic?
        @query.arabic?
      end

      def is_phase?
        @query.split.size > 2
      end

      def transliteration_clean
        @query = @query.downcase

        transliteration_rules.each do |rule|
          @query = @query.gsub(rule[0], rule[1])
        end

        @query
      end
    end
  end
end
