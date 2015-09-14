module Search
  class Request
    attr_accessor :params, :ayahs, :keys, :doc_count, :results, :min, :max

    def initialize(params, min = nil, max = nil)
      @params = params
      @min = min
      @max = max
    end

    def search
      Search::Results.new(Search.client.search(@params).merge(min: @min, max: @max))
    end
  end
end
