# frozen_string_literal: true

module Api::V3
  class VersesController < ApiController
    # GET /chapter-id-or-slug/verses
    # GET /1/verses
    # GET /surah-al-fatihah/verses
    def index
      finder = VerseFinder.new(params)
      verses = finder.load_verses(fetch_locale)

      render json: verses,
             meta: pagination_dict(finder),
             include: '**'
    end

    # GET /chapter-id-or-slug/verses/verse-number
    # GET /1/verses/1
    # GET /surah-al-fatihah/verses/1
    def show
      #finder = VerseFinder.new(params)
      render
    end

    private
    def pagination_dict(finder)
      {
        current_page: finder.current_page,
        next_page: finder.next_page,
        prev_page: finder.prev_page,
        total_pages: finder.total_pages,
        total_count: finder.total_verses
      }
    end
  end
end
