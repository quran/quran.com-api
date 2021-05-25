# frozen_string_literal: true

class VersesPresenter < BasePresenter
  attr_reader :lookahead, :finder, :qcf_font_version
  VERSE_FIELDS = [
    'chapter_id',
    'text_indopak',
    'text_imlaei_simple',
    'text_imlaei',
    'text_uthmani',
    'text_uthmani_simple',
    'text_uthmani_tajweed',
    'image_url',
    'image_width',
    'code_v1',
    'code_v2',
    'page_number',
    'v1_page',
    'v2_page'
  ]

  WORDS_FIELDS = [
    'verse_id',
    'chapter_id',
    'text_uthmani',
    'text_indopak',
    'text_imlaei_simple',
    'text_imlaei',
    'text_uthmani_simple',
    'text_uthmani_tajweed',
    'verse_key',
    'location',
    'code_v1',
    'code_v2',
    'v1_page',
    'v2_page',
    'line_number',
    'line_v2'
  ]

  TRANSLATION_FIELDS = [
    'chapter_id',
    'verse_number',
    'verse_key',
    'juz_number',
    'hizb_number',
    'rub_number',
    'page_number',
    'resource_name',
    'language_name',
    'language_id',
    'id'
  ]

  TAFSIR_FIELDS = [
    'chapter_id',
    'verse_number',
    'verse_key',
    'juz_number',
    'hizb_number',
    'rub_number',
    'page_number',
    'resource_name',
    'language_name',
    'language_id',
    'id'
  ]

  def initialize(params, lookahead)
    super(params)

    @lookahead = lookahead
    @finder = V4::VerseFinder.new(params)
  end

  def random_verse(language)
    filters = {
      chapter_id: params[:chapter_number],
      page_number: params[:page_number],
      juz_number: params[:juz_number],
      hizb_number: params[:hizb_number],
      rub_number: params[:rub_number]
    }.compact

    @finder.random_verse(
      filters,
      language,
      tafsirs: fetch_tafsirs,
      translations: fetch_translations,
      audio: fetch_audio
    )
  end

  def find_verse(filter, language)
    case filter
    when 'by_key'
      @finder.find_with_key(
        params[:verse_key],
        language,
        tafsirs: fetch_tafsirs,
        translations: fetch_translations,
        audio: fetch_audio
      )
    end
  end

  delegate :total_records, to: :finder

  def verse_fields
    strong_memoize :fields do
      if (fields = params[:fields]).presence
        fields.split(',').select do |field|
          VERSE_FIELDS.include?(field)
        end
      else
        []
      end
    end
  end

  def word_fields
    strong_memoize :word_fields do
      if (fields = params[:word_fields]).presence
        fields = sanitize_query_fields(fields.split(','))

        # If client has requested v1 or v2 codes
        # Remove line_number and page_number
        # We'll return these fields based on font version
        if fields.include?('code_v1')
          @qcf_font_version = :v1
          fields.delete('line_number')
          fields.delete('page_number')
        elsif fields.include?('code_v2')
          @qcf_font_version = :v2
          fields.delete('line_number')
          fields.delete('page_number')
        else
          @qcf_font_version = nil
        end

        fields.select do |field|
          WORDS_FIELDS.include?(field)
        end
      else
        @qcf_font_version = :v1

        ['code_v1', 'page_number']
      end
    end
  end

  def translation_fields
    strong_memoize :translation_fields do
      if (fields = params[:translation_fields]).presence
        fields.split(',').select do |field|
          TRANSLATION_FIELDS.include?(field)
        end
      else
        []
      end
    end
  end

  def tafsir_fields
    strong_memoize :tafsir_fields do
      if (fields = params[:tafsir_fields]).presence
        fields.split(',').select do |field|
          TAFSIR_FIELDS.include?(field)
        end
      else
        []
      end
    end
  end

  def verses(filter, language)
    finder.load_verses(filter, language, words: render_words?, tafsirs: fetch_tafsirs, translations: fetch_translations, audio: fetch_audio)
  end

  def render_words?
    strong_memoize :words do
      @lookahead.selects?('words')
    end
  end

  def render_translations?
    strong_memoize :translations do
      @lookahead.selects?('translations') && fetch_translations.present?
    end
  end

  def render_audio?
    strong_memoize :auido do
      @lookahead.selects?('audio')
    end
  end

  def render_tafsirs?
    strong_memoize :tafsir do
      @lookahead.selects?('tafsirs')
    end
  end

  protected

  def fetch_tafsirs
    if params[:tafsirs]
      params[:tafsirs].to_s.split(',')
    end
  end

  def fetch_translations
    strong_memoize :approve_translations do
      if params[:translations]
        translations = params[:translations].to_s.split(',')

        approved_translations = ResourceContent
                                  .approved
                                  .translations
                                  .one_verse

        params[:translations] = approved_translations
                                  .where(id: translations)
                                  .or(approved_translations.where(slug: translations))
                                  .pluck(:id)
        params[:translations]
      end
    end
  end

  def fetch_audio
    if params[:audio]
      params[:audio].to_i.abs
    end
  end
end
