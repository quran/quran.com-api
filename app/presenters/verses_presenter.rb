class VersesPresenter < BasePresenter
  attr_reader :lookahead, :finder
  VERSE_FIELDS = [
      "chapter_id",
      "verse_number",
      "verse_key",
      "text_uthmani",
      "text_indopak",
      "text_imlaei_simple",
      "juz_number",
      "hizb_number",
      "rub_number",
      "sajdah_type",
      "sajdah_number",
      "page_number",
      "image_url",
      "image_width",
      "text_imlaei",
      "text_uthmani_simple",
      "text_uthmani_tajweed"
  ]

  WORDS_FIELDS = [
      "verse_id",
      "chapter_id",
      "position",
      "text_uthmani",
      "text_indopak",
      "text_imlaei_simple",
      "verse_key",
      "page_number",
      "class_name",
      "line_number",
      "code_dec",
      "code_hex",
      "audio_url",
      "location",
      "char_type_name",
      "text_imlaei",
      "text_uthmani_simple",
      "text_uthmani_tajweed",
  ]

  TRANSLATION_FIELDS = [

  ]

  TAFSIR_FIELDS = [

  ]

  def initialize(params, lookahead)
    super(params)

    @lookahead = lookahead
    @finder = V4::VerseFinder.new(params)
  end

  def random_verse(language)
    filters = {
        page_number: params[:page_number],
        chapter_id: params[:chapter_number],
        juz_number: params[:juz_number]
    }.compact

    @finder.random_verse(
        filters,
        language,
        tafsirs: fetch_tafsirs,
        translations: fetch_translations,
        audio: fetch_audio
    )
  end

  def total_records
    finder.total_records
  end

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
        fields.split(',').select do |field|
          WORDS_FIELDS.include?(field)
        end
      else
        []
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

  def next_page
    finder.next_page
  end

  def current_page
    finder.current_page
  end

  def per_page
    finder.per_page
  end

  def total_records
    finder.total_records
  end

  def total_pages
    finder.total_pages
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
