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
        Translation.order('verse_id ASC').where(resource_filters(resource))
      else
        []
      end

      @fields = ['verse_id', 'verse_key']

      render
    end

    def tafsir
      @tafsirs = if (resource = fetch_tafsir_resource)
        Tafsir.order('verse_id ASC').where(resource_filters(resource))
      else
        []
      end

      @fields = ['verse_id', 'verse_key']

      render
    end

    def recitation
      @audio_files = AudioFile.order('verse_id ASC').where(resource_filters(resource))
      render
    end

    def verses_text
      @script_type = fetch_script_type
      @verses = Verse
                    .unscope(:order)
                    .order('verse_index ASC').where(resource_filters)
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

    def resource_filters(resource = nil)
      {
          resource_content_id: resource&.id,
          chapter_id: params[:chapter_number],
          juz_number: params[:juz_number],
          hizb_number: params[:hizb_number],
          rub_number: params[:rub_number],
          page_number: params[:page_number]
      }.compact
    end
  end
end
