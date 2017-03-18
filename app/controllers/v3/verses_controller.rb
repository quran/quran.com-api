class V3::VersesController < ApplicationController
  # GET /verses
  def index
    verses = Verse
             .where(chapter_id: params[:chapter_id])
             .includes(:media_contents, words: [
               :char_type,
               :audio,
               eager_language('translations'),
               eager_language('transliterations')
              ])
             .page(page)
             .per(per_page)

    verses = verses.offset(offset) if offset.present?
    verses = verses.padding(padding) if padding.present?

    render json: verses,
           meta: pagination_dict(verses),
           include: '**'
  end

  # GET /verses/1
  def show
    chapter = Chapter.find(params[:chapter_id])
    verse = chapter
            .verses
            .includes(words: [:char_type, :audio])
            .find(params[:id])

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
    params[:offset] ? params[:offset].to_i.abs : nil
  end

  def padding
    params[:padding] ? params[:padding].to_i.abs : nil
  end

  def eager_language(type)
    "#{params[:language] || 'en'}_#{type}".to_sym
  end
end
