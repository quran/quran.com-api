class V3::OptionsController < ApplicationController
  # GET /chapters
  def default
    chapters = Chapter.includes(:translated_names).all

    render json: chapters, params: params, a: :b
  end

  # GET /chapters/1
  def languages
    languages = Language.all

    render json: languages
  end

  def translations

  end

  def recitations

  end

  def media_content

  end

  def tafsirs

  end

end