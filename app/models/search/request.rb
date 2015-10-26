module Search
  class Request
    attr_accessor :params, :ayahs, :keys, :doc_count, :results, :min, :max

    def initialize(params, page = nil, size = nil)
      @params = params
      @page = page
      @size = size
    end

    def search
      Search::Results.new(Search.client.search(@params).merge(page: @page, size: @size))
    end
  end
end
