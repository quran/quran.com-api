class V3::VersesController < ApplicationController
  # GET /verses
  def index
    chapter = Chapter.find(params[:chapter_id])
    verses = chapter.verses.includes(:words).page(params[:page]).per(10)

    render json: verses,  meta: pagination_dict(verses)
  end

  # GET /verses/1
  def show
    render json: @verse
  end

  private

  def pagination_dict(object)
    {
        current_page: object.current_page,
        next_page: object.next_page,
        prev_page: object.prev_page,
        total_pages: object.total_pages,
        total_count: object.total_count
    }
  end
end
