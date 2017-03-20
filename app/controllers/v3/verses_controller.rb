class V3::VersesController < ApplicationController
  # GET /verses
  def index
    verses_index
    set_offset_and_padding
    load_audio
    load_translations

    render json: @verses,
           meta: pagination_dict(@verses),
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

  def render_audio?
    params[:recitation].present?
  end

  def render_translations?
    params[:translations].present?
  end

  def render_media?
    params[:media].present?
  end

  def word_includes
    [
      :char_type,
      :audio,
      eager_language('translations'),
      eager_language('transliterations')
    ]
  end

  def verses_index
    @verses = Verse
              .where(chapter_id: params[:chapter_id])
              .preload(:media_contents, words: word_includes)
              .page(page)
              .per(per_page)
  end

  def set_offset_and_padding
    @verses = @verses.offset(offset) if offset.present?
    @verses = @verses.padding(padding) if padding.present?
  end

  def load_audio
    return unless render_audio?
    @verses = @verses
              .where('audio_files.recitation_id = ?', params[:recitation])
              .eager_load(:audio_files)
  end

  def load_translations
    return unless render_translations?
    translations = {
      resource_content_id: params[:translations]
    }

    @verses = @verses
              .where(translations: translations)
              .eager_load(:translations)
  end
end
