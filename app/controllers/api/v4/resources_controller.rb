# frozen_string_literal: true

module Api::V4
  class ResourcesController < ApiController
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

      @translations = eager_load_translated_name(list)

      render
    end

    def translation_info
      @translation = fetch_translation_resource

      render
    end

    def tafsirs
      list = ResourceContent
                 .eager_load(:translated_name)
                 .one_verse
                 .tafsirs
                 .approved
                 .order('priority ASC')

      @tafsirs = eager_load_translated_name(list)

      render
    end

    def tafsir_info
      @tafsir = fetch_tafsir_resource
      render
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
                       .find(params[:recitation_id])

      @resource = @recitation.resource_content

      render
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

    def verses_text
      @script_type = fetch_script_type
      @verses = Verse.select(:id, :verse_key, @script_type)

      render
    end

    protected
    def fetch_script_type
      script = params[:script]

      if VERSE_AVAILABLE_SCRIPTS.include?(script)
        script
      else
        'text_uthmani'
      end
    end

    def chapters
      finder = ChapterFinder.new
      finder.all_with_translated_names(fetch_locale)
    end

    def chapter
      finder = ChapterFinder.new
      finder.find_with_translated_name(params[:id], fetch_locale)
    end
  end
end
