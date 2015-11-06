module Search
  class Request
    include Virtus.model

    attribute :params, Hash
    attribute :type, Symbol

    def initialize(params, type = :aggregations)
      @params = params
      @type = type
    end

    def search
      Search::Results.new(Search.client.search(@params), @type)
    end
  end
end
