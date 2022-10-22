# frozen_string_literal: true

module Api::V4
  class ResourcesController < ApiController
    #TODO: move the logic to presenters
    def chapter_reciters
      @presenter = ::Audio::RecitationPresenter.new(params)
      render
    end

    def translations
      list = ResourceContent
               .eager_load(:translated_name)
               .one_verse
               .translations
               .approved
               .order('priority ASC')

      @presenter = ResourcePresenter.new(params)
      @translations = eager_load_translated_name(list)

      render
    end

    def translation_info
      if @translation = fetch_translation_resource
        render
      else
        render_404("Translation not found")
      end
    end

    def tafsirs
      list = ResourceContent
               .eager_load(:translated_name)
               .tafsirs
               .approved
               .order('priority ASC')

      @presenter = ResourcePresenter.new(params)
      @tafsirs = eager_load_translated_name(list)

      render
    end

    def tafsir_info
      if @tafsir = fetch_tafsir_resource
        render
      else
        render_404("Tafsir not found")
      end
    end

    def recitations
      list = Recitation
               .eager_load(reciter: :translated_name)
               .approved
               .order('translated_names.language_priority desc')

      @recitations = eager_load_translated_name(list)

      render
    end

    def recitation_info
      @recitation = Recitation
                      .includes(:resource_content)
                      .approved
                      .find_by(id: params[:recitation_id])

      if @resource = @recitation&.get_resource_content
        render
      else
        render_404("Recitation not found")
      end
    end

    def recitation_styles
      render
    end

    def chapter_infos
      list = ResourceContent
               .eager_load(:translated_name)
               .chapter_info
               .one_chapter
               .approved

      @chapter_infos = eager_load_translated_name(list)

      render
    end

    def verse_media
      @media = ResourceContent
                 .includes(:language)
                 .media
                 .one_verse.approved

      render
    end

    def languages
      list = Language.with_translations.eager_load(:translated_name)
      @languages = eager_load_translated_name(list)

      render
    end

    def changes
      if time = after_timestamp
         @resources = ResourceContent.changes(after: time)
         render
      else
        render_422("Pass in valid datetime")
      end
    end
  end
end
