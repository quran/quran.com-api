# frozen_string_literal: true

module Search
  class Client
    # Debug ES queries only in development environment
    DEBUG_ES_QUERIES = Rails.env.development?
    DEFAULT_RESULT_SIZE = 10
    NAVIGATE_RESULT_SIZE = 30
    MAX_RESULT_SIZE = 50

    include QuranUtils::StrongMemoize

    attr_accessor :query,
                  :options,
                  :page,
                  :per_page,
                  :filter_languages,
                  :filter_translations

    def initialize(query, options = {})
      @query = Qdc::Search::Query.new(query)
      @options = options
      @page = options[:page].to_i.abs
      @per_page = options[:per_page]
      @navigate_per_page = options[:per_page]
      @filter_languages = options[:filter_languages]
      @filter_translations = options[:filter_translations]
    end

    def result_size
      [@per_page || DEFAULT_RESULT_SIZE, MAX_RESULT_SIZE].min
    end
  end
end
