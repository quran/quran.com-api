class V3::OptionsController < ApplicationController
  # GET /chapters
  def default
    chapters = Chapter.includes(:translated_names).all

    render json: chapters
  end

  # GET /chapters/1
  def languages
    languages = Language.all

    render json: languages
  end

  def translations
    resources = ResourceContent.translations.one_verse.approved

    render json: resources, key: :translations
  end

  def recitations
    resources = Recitation.approved

    render json: resources
  end

  def media_content

  end

  def tafsirs

  end

end