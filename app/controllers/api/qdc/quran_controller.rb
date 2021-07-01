# frozen_string_literal: true

module Api::Qdc
  class QuranController < ApiController
    VERSE_AVAILABLE_SCRIPTS = [
        'text_uthmani',
        'text_uthmani_simple',
        'text_uthmani_tajweed',
        'text_indopak',
        'text_imlaei',
        'text_imlaei_simple',
        'code_v1',
        'code_v2'
    ]

    def translation
      @presenter = TranslationsPresenter.new(params)

      @translations = if (@resource = fetch_translation_resource)
        Translation.order('verse_id ASC').where(resource_filters(@resource))
      else
        []
      end

      render
    end

    def tafsir
      @presenter = TafsirsPresenter.new(params)

      @tafsirs = if (@resource = fetch_tafsir_resource)
        Tafsir.order('verse_id ASC').where(resource_filters(@resource))
      else
        []
      end

      render
    end

    def recitation
      @presenter = RecitationsPresenter.new(params)

      @audio_files = if (@recitation = fetch_approved_recitation)
        filters = resource_filters
        filters[:recitation_id] = @recitation.id

        @audio_files = AudioFile.order('verse_id ASC').where(filters)
      else
        []
      end

      render
    end

    def verses_text
      @script_type = fetch_script_type
      @extra_fields = []

      if 'code_v1' == @script_type
        @extra_fields << :v1_page
      end

      if 'code_v2' == @script_type
        @extra_fields << :v2_page
      end

      @verses = Verse
                    .unscope(:order)
                    .order('verse_index ASC').where(resource_filters)
                    .select(:id, :verse_key, @script_type, *@extra_fields)

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
          page_number: params[:page_number],
          verse_key: params[:verse_key]
      }.compact
    end

    def fetch_approved_recitation
      list = Recitation
                 .approved

      list.where(id: params[:recitation_id]).first
    end
  end
end
