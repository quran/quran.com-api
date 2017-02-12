class V3::VersesController < ApplicationController
  # GET /verses
  def index
    chapter = Chapter.find(params[:chapter_id])
    verses = chapter.verses.includes(words: [:char_type, :audio]).page(page).per(per_page).offset(offset)

    render json: verses,
           meta: pagination_dict(verses),
           include: '**'
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

  def page
    params[:page].to_i.abs
  end

  def per_page
    limit = (params[:limit] || 10).to_i.abs
    limit <= 50 ? limit : 50
  end

  def offset
    params[:offset].to_i.abs
  end
end
