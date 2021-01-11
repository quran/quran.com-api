# frozen_string_literal: true
module Api::V4
  class QuranController < ApiController
    VERSE_AVAILABLE_SCRIPTS = [
        'text_uthmani',
        'text_uthmani_simple',
        'text_uthmani_tajweed',
        'text_indopak',
        'text_imlaei',
        'text_imlaei_simple'
    ]

    def translation
      @translations = if (resource = fetch_translation_resource)
                        Translation.order('verse_id ASC').where(resource_content_id: resource)
                      else
                        []
                      end

      render
    end

    def tafsir
      @tafsirs = Tafsir.order('verse_id ASC').where(resource_content_id: fetch_tafsir_id)
      render
    end

    def recitation
      @audio_files = AudioFile.order('verse_id ASC').where(recitation_id: params[:recitation_id])
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
