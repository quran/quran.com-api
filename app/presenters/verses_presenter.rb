class VersesPresenter < BasePresenter
  attr_reader :lookahead, :finder

  def initialize(params, context)
    super(params, context)

    @lookahead = RestApi::ParamLookahead.new(params)
    @finder = V4::VerseFinder.new(params, lookahead)
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
    if params[:translations]
      params[:translations].to_s.split(',')
    end
  end

  def fetch_audio
    if params[:audio]
      params[:audio].to_i.abs
    end
  end
end
