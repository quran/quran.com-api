module Search
  class QueryString
    attr_accessor :query

    def initialize(query)
      @query = query.force_encoding('UTF-8')
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
