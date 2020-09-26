# frozen_string_literal: true
module Api
  class V3::OptionsController < ApplicationController
    # GET options/default
    def default
      # Defaults:
      # Translation: Sahih International(English)
      # Recitation: Qari Abdul Baset(Mujawwad style)
      # Media: Bayyinah ( 61 )
      render json: {translations: [21], language: 'en', recitation: 1, media: 61}
    end

    # GET options/languages
    def languages
      list = Language.with_translations.eager_load(:translated_name)
      languages = eager_load_translated_name(list)

      render json: languages
    end

    # GET options/translations
    def translations
      resources = ResourceContent
                    .translations
                    .one_verse
                    .approved

      render json: resources, root: 'translations'
    end

    # GET options/recitations
    def recitations
      language = Language.find_by_id_or_iso_code('ar')
      list = Recitation.eager_load(reciter: :translated_name).approved.order('translated_names.language_priority desc')

      #with_default_name = list.where(translated_names: {language_id: Language.default.id})
      #names = list.where(translated_names: {language_id: language}).or(with_default_name)

      reciters = eager_load_translated_name(list)

      render json: reciters
    end

    # GET options/chapter_info
    def chapter_info
      resources = ResourceContent.includes(:language).chapter_info.one_chapter.approved

      render json: resources, root: :chapter_info
    end

    # GET options/media_content
    def media_content
      resources = ResourceContent.includes(:language).media.one_verse.approved

      render json: resources, root: :media
    end

    # GET options/tafsirs
    def tafsirs
      resources = ResourceContent.includes(:language).tafsirs.one_verse.approved

      render json: resources, root: :tafsirs
    end
  end
end
