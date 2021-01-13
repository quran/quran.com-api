# frozen_string_literal: true
module Api::V4
  class ResourcesController < ApiController
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

    def fetch_translation_id
      approved = ResourceContent
                     .tafsirs
                     .one_verse
                     .approved

      find_resource(approved, params[:translation_id])
    end

    def fetch_translation_resource
      approved = ResourceContent
                     .tafsirs
                     .one_verse
                     .approved

      find_resource(approved, params[:tafsir_id])
    end

    def find_resource(list, key)
      with_ids = list.where(id: key.to_i)
      with_slug = approved.where(slug: key)

      with_ids.or(with_slug).first
    end
  end
end
