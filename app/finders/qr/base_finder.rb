module Qr
  class BaseFinder < Finder
    include Pagy::Backend
    attr_reader :pagination

    def per_page
      strong_memoize :per_page do
        items_per_page = (params[:per_page].presence || 10).to_i
        [items_per_page, 20].min
      end
    end

    def next_page
      pagination.next
    end

    def current_page
      pagination.page
    end

    def total_records
      pagination.count
    end

    def total_pages
      pagination.pages
    end

    protected

    def paginate(records)
      # pagy expect to start page number from 1, 0 will throw an exception
      page = [params[:page].to_i, 1].max
      @pagination, @results = pagy(records, items: per_page, page: page)
      @results
    end
  end
end