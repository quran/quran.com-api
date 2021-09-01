# frozen_string_literal: true

module Search
  class Client
    # Debug es queries only in dev environment
    DEBUG_ES_QUERIES = Rails.env.development?
    DEFAULT_RESULT_SIZE = 10
    include QuranUtils::StrongMemoize

    attr_accessor :query,
                  :options,
                  :page,
                  :per_page,
                  :language

    def initialize(query, options = {})
      @query = Qdc::Search::Query.new(query)
      @options = options
      @page = options[:page].to_i.abs
      @per_page = options[:per_page]
      @language = options[:language]
      @translations = options[:translations]
    end

    def result_size
      @per_page || DEFAULT_RESULT_SIZE
    end
  end
end
