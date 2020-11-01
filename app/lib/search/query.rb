# frozen_string_literal: true

module Search
  class Query
    attr_reader :query

    REGEXP = Regexp.union(%w_+ - = & | > < ! ( ) { } [ ] ^ " ~ * ?_)

    def initialize(query)
      @query = query.to_s.force_encoding('ASCII-8BIT').
               force_encoding('UTF-8').
               gsub(/[:\/\\]+/, ':').
               gsub(REGEXP) { |m| "\\#{m}" }
    end

    def is_arabic?
      @query.arabic?
    end

    def query
      @query
    end

    def language_match
      @query.prose
    end
  end
end
