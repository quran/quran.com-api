class V3::OptionsController < ApplicationController
  # GET /chapters
  def default
    # Defaults:
    # Translation: Sahih International(English)
    # Recitation: Qari Abdul Baset(Mujawwad style)
    render json: {translations: [21], language: 'en', recitation: 1}
  end

  # GET /chapters/1
  def languages
    languages = Language.all

    render json: languages
  end

  def translations
    resources = ResourceContent.translations.one_verse.approved

    render json: resources, root: :translations
  end

  def recitations
    resources = Recitation.approved

    render json: resources
  end

  def chapter_info
    resources = ResourceContent.chapter_info.one_chapter.approved

    render json: resources, root: :chapter_info
  end

  def media_content
    resources = ResourceContent.media.one_verse.approved

    render json: resources, root: :media
  end

  def tafsirs
    resources = ResourceContent.tafsirs.one_verse.approved

    render json: resources, root: :tafisrs
  end
end