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
      'qpc_uthmani_hafs', #TODO: deprecated and renamed to text_qpc_hafs
      'text_qpc_hafs',
      'text_qpc_nastaleeq_hafs',
      'text_qpc_nastaleeq',
      'text_nastaleeq_indopak',
      'verse_key',
      'location',
      'code_v1',
      'code_v2',
      'v1_page',
      'v2_page',
      'line_number',
      'line_v2',
      'line_v1',
      'position',
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
        rub_el_hizb_number: params[:rub_el_hizb_number],
        ruku_number: params[:ruku_number],
        manzil_number: params[:manzil_number]
      }.compact_blank

      @finder.random_verse(
        filters,
        fetch_word_translation_language,
        mushaf_type: get_mushaf_id,
        tafsirs: fetch_tafsirs,
        translations: fetch_translations,
        reciter: fetch_reciter
      )
    end

    def find_verse
      case verses_filter
      when 'by_key'
        result = @finder.find_with_key(
          params[:verse_key],
          fetch_word_translation_language,
          mushaf_type: get_mushaf_id,
          tafsirs: fetch_tafsirs,
          translations: fetch_translations,
          reciter: fetch_reciter
        )

        raise_404("Ayah not found") unless result
        result
      end
    end

    def verses
      strong_memoize :verses do
        finder.load_verses(verses_filter,
                           fetch_word_translation_language,
                           mushaf_type: get_mushaf_id,
                           words: render_words?,
                           tafsirs: fetch_tafsirs,
                           translations: fetch_translations,
                           reciter: fetch_reciter)
      end
    end

    def fetch_chapters
      chapters = Chapter.where(id: chapter_ids).includes(:translated_name)

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
        @lookahead.selects?('reciter') && fetch_reciter
      end
    end

    protected

    def chapter_ids
      verses.pluck(:chapter_id).uniq
    end

    def fetch_reciter
      strong_memoize :fetch_reciter do
        if params[:reciter] && params[:reciter].to_i > 0
          Audio::Recitation.approved.find_by(id: params[:reciter].to_i)&.id
        end
      end
    end
  end
end