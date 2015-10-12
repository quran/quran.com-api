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

    def contains_or?
      # Does the query contain 'or', for example
      # 'Isa or Nuh'
      @query.downcase.include?(' or ')
    end

    def is_OR_type?
      self.contains_or?
    end

    def is_AND_type?
      !self.contains_or?
    end

    def is_phase?
      @query.split.size > 2
    end

    def or_type_queries
      @query.downcase.split('or')
    end

    def transliteration_rules
      [
        ['oo', 'u'],
        ['-', ''],
        ['aa', 'a'],
        ['ia', 'i'],
        ['7', 'h']
      ]
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
