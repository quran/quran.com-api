# frozen_string_literal: true

module Api
  class V3::OptionsController < ApiController
    # GET options/default
    def default
      render json: { translations: [21], language: 'en', recitation: 1, media: 61 }
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
      list = Recitation
               .eager_load(reciter: :translated_name)
               .approved
               .order('translated_names.language_priority desc')

      reciters = eager_load_translated_name(list)

      render json: reciters
    end

    # GET options/chapter_info
    def chapter_info
      list = ResourceContent
               .eager_load(:translated_name)
               .chapter_info
               .one_chapter
               .approved

      resources = eager_load_translated_name(list)

      render json: resources, root: 'chapter_info'
    end

    # GET options/media_content
    def media_content
      resources = ResourceContent
                    .includes(:language)
                    .media
                    .one_verse.approved

      render json: resources, root: 'media'
    end

    # GET options/tafsirs
    def tafsirs
      list = ResourceContent
               .eager_load(:translated_name)
               .tafsirs
               .one_verse
               .approved

      resources = eager_load_translated_name(list)

      render json: resources, root: 'tafsirs'
    end
  end
end
