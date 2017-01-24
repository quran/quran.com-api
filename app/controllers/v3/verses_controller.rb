class V3::VersesController < ApplicationController
  # GET /verses
  def index
    chapter = Chapter.find(params[:chapter_id])
    verses = chapter.verses.includes(words: [:char_type, :audio]).page(params[:page]).per(10)

    render json: verses,  meta: pagination_dict(verses), include: '**'
  end

  # GET /verses/1
  def show
    chapter = Chapter.find(params[:chapter_id])
    verse = chapter.verses.includes(words: [:char_type, :audio]).find(params[:id])

    render json: verse, include: '**'
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
