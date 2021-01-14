# frozen_string_literal: true

class V4::VerseFinder < ::VerseFinder
  attr_reader :lookahead

  def initialize(params, lookahead)
    super params
    @lookahead = lookahead
  end

  def random_verse(filters, language_code, words: true, tafsirs: false, translations: false, audio: false)
    @results = Verse.unscope(:order).where(filters).order("RANDOM()").limit(3)

    load_translations(translations) if translations.present?
    load_words(language_code) if words
    load_audio(audio) if audio
    load_tafsirs(tafsirs) if tafsirs.present?

    @results.sample
  end

  def load_verses(filter, language_code, words: true, tafsirs: false, translations: false, audio: false)
    fetch_verses_range(filter)
    load_translations(translations) if translations.present?
    load_words(language_code) if words
    load_audio(audio) if audio
    load_tafsirs(tafsirs) if tafsirs.present?

    words_ordering = words ? ', words.position ASC, word_translations.priority ASC' : ''

    @results.order("verses.verse_index ASC #{words_ordering}".strip)
  end

  def fetch_verses_range(filter)
    @results = send("fetch_#{filter}")
  end

  def per_page
    limit = (params[:per_page] || 10).to_i.abs
    limit <= 50 ? limit : 50
  end

  protected

  def fetch_by_chapter
    chapter = Chapter.find(params[:chapter_number].to_i.abs)
    total_verses = chapter.verses_count
    verse_start = verse_pagination_start(total_verses)
    verse_end = verse_pagination_end(verse_start, total_verses)

    Verse
        .where(chapter_id: params[:chapter_number].to_i.abs)
        .where('verses.verse_number >= ? AND verses.verse_number <= ?', verse_start.to_i, verse_end.to_i)
  end

  def fetch_by_page
    Verse.where(page_number: params[:page_number].to_i.abs)
  end

  def fetch_by_juz
    if juz = Juz.find_by_juz_number(params[:juz_number].to_i.abs)
      total_verses = chapter.verses_count
      verse_start = verse_pagination_start(total_verses)
      verse_end = verse_pagination_end(verse_start, total_verses)

      Verse
          .where(juz_number: params[:juz_number].to_i.abs)
          .where('verses.verse_number >= ? AND verses.verse_number <= ?', verse_start.to_i, verse_end.to_i)
    else
      Verse.where('1=0')
    end
  end

  def verse_pagination_start(total_verses)
    from = (params[:from] || 1).to_i.abs
    start = from + (current_page - 1) * per_page

    min(start, total_verses)
  end

  def verse_pagination_end(start, total_verses)
    to = params[:to].presence ? params[:to].to_i.abs : nil
    verse_to = min(to || total_verses, total_verses)

    min((start + per_page) - 1, verse_to)
  end

  def load_words(word_translation_lang)
    language = Language.find_by_id_or_iso_code(word_translation_lang)

    words_with_default_translation = @results.where(word_translations: {language_id: Language.default.id})

    if (language)
      @results = @results
                     .where(word_translations: {language_id: language.id})
                     .or(words_with_default_translation)
                     .eager_load(words: eager_load_words)
    else
      @results = words_with_default_translation.eager_load(words: eager_load_words)
    end
  end

  def load_translations(translations)
    @results = @results
                   .where(translations: {resource_content_id: translations})
                   .eager_load(:translations)
  end

  def load_tafsirs(tafsirs)
    @results = @results
                   .where(tafsirs: {resource_content_id: tafsirs})
                   .eager_load(:tafsirs)
  end

  def load_audio(recitation)
    @results = @results
                   .where(audio_files: {recitation_id: recitation})
                   .eager_load(:audio_file)
  end
end