# frozen_string_literal: true

module Api::V4
  class QuranController < ApiController
    def translation
      @presenter = TranslationsPresenter.new(params)
      @resource = fetch_translation_resource
      filters = resource_filters(@resource)
      @filter_names = humanize_filter_names(filters)

      @translations = if @resource
                        Translation.order('verse_id ASC').where(filters)
                      else
                        []
                      end

      render
    end

    def tafsir
      @presenter = TafsirsPresenter.new(params)
      filters = resource_filters(@resource)
      @filter_names = humanize_filter_names(filters)

      @tafsirs = if (@resource = fetch_tafsir_resource)
                   Tafsir.order('verse_id ASC').where(filters)
                 else
                   []
                 end

      render
    end

    def recitation
      @presenter = RecitationsPresenter.new(params)
      filters = resource_filters
      @filter_names = humanize_filter_names(filters)

      @audio_files = if (@recitation = fetch_approved_recitation)
                       @filters[:recitation_id] = @recitation.id

                       @audio_files = AudioFile.order('verse_id ASC').where(filters)
                     else
                       []
                     end

      render
    end

    def verses_text
      @script_type = fetch_script_type
      @extra_fields = []
      filters = resource_filters
      @filter_names = humanize_filter_names(filters)

      if 'code_v1' == @script_type
        @extra_fields << :v1_page
      end

      if 'code_v2' == @script_type
        @extra_fields << :v2_page
      end

      @verses = Verse
                  .unscope(:order)
                  .order('verse_index ASC').where(filters)
                  .select(:id, :verse_key, @script_type, *@extra_fields)

      render
    end

    protected

    def fetch_script_type
      script = params[:script].to_s

      case script
      when 'uthmani_simple', 'text_uthmani_simple'
        'text_uthmani_simple'
      when 'uthmani_tajweed', 'text_uthmani_tajweed'
        'text_uthmani_tajweed'
      when 'indopak', 'text_indopak'
        'text_indopak'
      when 'imlaei', 'text_imlaei'
        'text_imlaei'
      when 'imlaei_simple', 'text_imlaei_simple'
        'text_imlaei_simple'
      when 'qpc_hafs', 'text_qpc_hafs'
        'text_qpc_hafs'
      when 'qpc_nastaleeq', 'text_qpc_nastaleeq'
        'text_qpc_nastaleeq'
      when 'nastaleeq_indopak', 'text_nastaleeq_indopak'
        'text_nastaleeq_indopak'
      when 'v1_image'
        'image_url'
      when 'code_v1', 'v1'
        'code_v1'
      when 'v2', 'code_v2'
        'code_v2'
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
        rub_el_hizb_number: params[:rub_el_hizb_number],
        ruku_number: params[:ruku_number],
        manzil_number: params[:manzil_number],
        page_number: params[:page_number],
        verse_key: params[:verse_key]
      }.compact_blank
    end

    def humanize_filter_names(filters)
      filters = filters.clone
      filters[:resource_id] = filters.delete(:resource_content_id)
      filters[:chapter_number] = filters.delete(:chapter_id)

      filters.compact_blank
    end

    def fetch_approved_recitation
      list = Recitation
               .approved

      list.where(id: params[:recitation_id]).first
    end
  end
end
