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
                        Translation.order('verse_id ASC').where(resource_content_id: resource.id)
                      else
                        []
                      end

      render
    end

    def tafsir
      @tafsirs = if (resource = fetch_tafsir_resource)
                   Tafsir.order('verse_id ASC').where(resource_content_id: resource.id)
                 else
                   []
                 end

      render
    end

    def recitation
      @audio_files = AudioFile.order('verse_id ASC').where(recitation_id: params[:recitation_id])
      render
    end

    def verses_text
      @script_type = fetch_script_type
      @verses = Verse
                    .unscope(:order)
                    .order('verse_index ASC')
                    .select(:id, :verse_key, @script_type)

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
