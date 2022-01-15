# frozen_string_literal: true

class VerseFinder < Finder
  def find(verse_number, language_code = 'en')
    load_verses(language_code).find_by_id_or_key(verse_number) || raise_invalid_ayah_number
  end

  def random_verse(filters, language_code, words: true, tafsirs: false, translations: false, reciter: false)
    @results = Verse.unscope(:order).where(filters).order('RANDOM()').limit(3)

    load_translations
    load_words(language_code)
    load_audio
    translations_order = params[:translations].present? ? ',translations.priority ASC' : ''

    @results.order("verses.verse_index ASC, words.position ASC, word_translations.priority ASC #{translations_order}".strip)
            .sample
  end


  def load_verses(language_code)
    fetch_verses_range
    load_translations
    load_words(language_code)
    load_audio
    translations_order = params[:translations].present? ? ',translations.priority ASC' : ''

    @results.order("verses.verse_index ASC, words.position ASC, word_translations.priority ASC #{translations_order}".strip)
  end

  protected

  def fetch_verses_range
    verse_start = verse_pagination_start
    verse_end = verse_pagination_end(verse_start)

    @results = Verse
                 .where(chapter_id: chapter.id)
                 .where('verses.verse_number >= ? AND verses.verse_number <= ?', verse_start.to_i, verse_end.to_i)
  end

  def load_words(word_translation_lang)
    language = Language.find_with_id_or_iso_code(word_translation_lang)

    words_with_default_translation = results.where(word_translations: { language_id: Language.default.id })

    if language
      @results = @results
                   .where(word_translations: { language_id: language.id })
                   .or(words_with_default_translation)
                   .eager_load(words: eager_load_words)
    else
      @results = words_with_default_translation
                   .eager_load(words: eager_load_words)
    end
  end

  def load_translations
    translations = params[:translations]

    if translations.present?
      @results = @results
                   .where(translations: { resource_content_id: translations })
                   .eager_load(:translations)
    end
  end

  def load_audio
    if params[:recitation].present?
      @results = @results
                   .where(audio_files: { recitation_id: params[:recitation] })
                   .eager_load(:audio_file)
    end
  end

  def set_offset
    if offset.present?
      @results = @results.offset(offset)
    end
  end

  def offset
    params[:offset] ? params[:offset].to_i.abs : nil
  end

  def eager_load_words
    :word_translation
  end

  def verse_pagination_start
    start = 1 + (current_page - 1) * per_page
    start = min(start, total_verses)
    if offset
      min(start + offset, total_verses)
    else
      start
    end
  end

  def verse_pagination_end(start)
    if params[:id]
      # for show page, skip the pagination
      min(params[:id].to_i, chapter.verses_count)
    else
      min((start + per_page) - 1, chapter.verses_count)
    end
  end

  def chapter
    strong_memoize :chapter do
      find_chapter
    end
  end
end
