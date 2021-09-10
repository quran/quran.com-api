# frozen_string_literal: true
module Qdc
  class VersesPresenter < ::VersesPresenter
    WORDS_FIELDS = [
      'verse_id',
      'chapter_id',
      'text_uthmani',
      'text_indopak',
      'text_imlaei_simple',
      'text_imlaei',
      'text_uthmani_simple',
      'text_uthmani_tajweed',
      'qpc_uthmani_hafs',
      'verse_key',
      'location',
      'code_v1',
      'code_v2',
      'v1_page',
      'v2_page',
      'line_number',
      'line_v2',
      'line_v1',
      'page_position',
      'line_position',
    ]

    def initialize(params, filter)
      super(params, filter)

      @finder = Qdc::VerseFinder.new(params)
    end

    def word_fields
      strong_memoize :word_fields do
        if (fields = params[:word_fields]).presence
          fields = sanitize_query_fields(fields.split(','))

          fields.select do |field|
            WORDS_FIELDS.include?(field)
          end
        else
          []
        end
      end
    end

    def random_verse
      filters = {
        chapter_id: params[:chapter_number],
        page_number: params[:page_number],
        juz_number: params[:juz_number],
        hizb_number: params[:hizb_number],
        rub_number: params[:rub_number]
      }.compact

      @finder.random_verse(
        filters,
        fetch_locale,
        mushaf_type: get_mushaf_id,
        tafsirs: fetch_tafsirs,
        translations: fetch_translations,
        audio: fetch_audio
      )
    end

    def find_verse
      case verses_filter
      when 'by_key'
        @finder.find_with_key(
          params[:verse_key],
          fetch_locale,
          mushaf_type: get_mushaf_id,
          tafsirs: fetch_tafsirs,
          translations: fetch_translations,
          audio: fetch_audio
        )
      end
    end

    def verses
      strong_memoize :verses do
        finder.load_verses(verses_filter,
                           fetch_locale,
                           mushaf_type: get_mushaf_id,
                           words: render_words?,
                           tafsirs: fetch_tafsirs,
                           translations: fetch_translations,
                           audio: fetch_audio)
      end
    end

    def fetch_chapters
      chapters = Chapter.where(id: chapter_ids).includes(:translated_name)
      language = Language.find_with_id_or_iso_code(fetch_locale)

      with_default_names = chapters
                             .where(
                               translated_names: { language_id: Language.default.id }
                             )

      chapters
        .where(translated_names: { language_id: language.id })
        .or(with_default_names)
        .order('translated_names.language_priority DESC')
    end

    def render_surah_detail?
      @lookahead.selects?('surah_detail')
    end

    def render_segments?
      strong_memoize :include_segments do
        @lookahead.selects?('reciter')
      end
    end

    protected

    def chapter_ids
      verses.pluck(:chapter_id).uniq
    end

    def fetch_audio
      if params[:audio]
        params[:audio].to_i.abs
      end
    end
  end
end