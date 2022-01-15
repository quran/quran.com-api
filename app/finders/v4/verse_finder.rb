# frozen_string_literal: true

class V4::VerseFinder < ::VerseFinder
  def random_verse(filters, language_code, words: true, tafsirs: false, translations: false, audio: false)
    @results = Verse.unscope(:order).where(filters).order('RANDOM()').limit(3)

    load_translations(translations) if translations.present?
    load_words(language_code) if words
    load_audio(audio) if audio
    load_tafsirs(tafsirs) if tafsirs.present?

    words_ordering = words ? ', words.position ASC, word_translations.priority ASC' : ''
    translations_order = translations.present? ? ',translations.priority ASC' : ''

    @results.order("verses.verse_index ASC #{words_ordering} #{translations_order}".strip).sample
  end

  def find_with_key(key, language_code, words: true, tafsirs: false, translations: false, audio: false)
    @results = Verse.where(verse_key: key).limit(1)

    load_translations(translations) if translations.present?
    load_words(language_code) if words
    load_audio(audio) if audio
    load_tafsirs(tafsirs) if tafsirs.present?

    words_ordering = words ? ', words.position ASC, word_translations.priority ASC' : ''
    translations_order = translations.present? ? ',translations.priority ASC' : ''

    @results.order("verses.verse_index ASC #{words_ordering} #{translations_order}".strip).first
  end

  def load_verses(filter, language_code, words: true, tafsirs: false, translations: false, audio: false)
    fetch_verses_range(filter)
    load_translations(translations) if translations.present?
    load_words(language_code) if words
    load_audio(audio) if audio
    load_tafsirs(tafsirs) if tafsirs.present?

    words_ordering = words ? ', words.position ASC, word_translations.priority ASC' : ''
    translations_order = translations.present? ? ',translations.priority ASC' : ''

    @results.order("verses.verse_index ASC #{words_ordering} #{translations_order}".strip)
  end

  def fetch_verses_range(filter)
    @results = send("fetch_#{filter}")
  end

  protected
  def fetch_advance_copy
    if params[:from] && params[:to]
      verse_from = QuranUtils::Quran.get_ayah_id_from_key(params[:from])
      verse_to = QuranUtils::Quran.get_ayah_id_from_key(params[:to])

      @verses = Verse
                  .unscoped
                  .order('verses.verse_index asc')
                  .where('verses.verse_index >= :from AND verses.verse_index <= :to', from: verse_from, to: verse_to)
    else
      @verses = Verse.none
    end

    @verses
  end

  def fetch_filter
    utils = QuranUtils::VerseRanges.new
    ids = utils.get_ids_from_ranges(params[:filters])
    results = Verse.unscoped.where(id: ids)

    @total_records = results.size
    @results = results.limit(per_page).offset((current_page - 1) * per_page)

    if current_page < total_pages
      @next_page = current_page + 1
    end

    @results
  end

  def fetch_by_chapter
    chapter = find_chapter
    @total_records = chapter.verses_count
    verse_start = verse_pagination_start
    verse_end = verse_pagination_end(verse_start, @total_records)
    @next_page = current_page + 1 if verse_end < params[:to]

    @results = Verse
                 .where(chapter_id: chapter.id)
                 .where('verses.verse_number >= ? AND verses.verse_number <= ?', verse_start.to_i, verse_end.to_i)
  end

  def fetch_by_page
    mushaf_page = find_mushaf_page
    # Disable pagination for by_page route
    @per_page = @total_records = mushaf_page.verses_count
    @next_page = nil

    @results = rescope_verses('verse_index').where(page_number: mushaf_page.page_number)
  end

  def fetch_by_rub_el_hizb
    rub_el_hizb = find_rub_el_hizb
    # Disable pagination for by_page route
    @per_page = @total_records = rub_el_hizb.verses_count
    @next_page = nil

    @results = rescope_verses('verse_index').where(rub_el_hizb_number: rub_el_hizb.rub_el_hizb_number)
  end

  def fetch_by_hizb
    results = rescope_verses('verse_index')
                .where(hizb_number: find_hizb_number)

    @total_records = results.size
    @results = results.limit(per_page).offset((current_page - 1) * per_page)

    if current_page < total_pages
      @next_page = current_page + 1
    end

    @results
  end

  def fetch_by_juz
    juz = find_juz
    verse_start = juz.first_verse_id + (current_page - 1) * per_page
    verse_end = min(verse_start + per_page, juz.last_verse_id)
    if verse_end < juz.last_verse_id
      @next_page = current_page + 1
    end
    @total_records = juz.verses_count

    @results = rescope_verses('verse_index')
                 .where(juz_number: juz.juz_number)
                 .where('verses.verse_index >= ? AND verses.verse_index < ?', verse_start.to_i, verse_end.to_i)
  end

  def fetch_by_ruku
    ruku = find_ruku
    # Disable pagination for ruku route
    @per_page = @total_records = ruku.verses_count
    @next_page = nil

    @results = rescope_verses('verse_index').where(ruku_number: ruku.ruku_number)
  end

  def fetch_by_manzil
    manzil = find_manzil
    verse_start = manzil.first_verse_id + (current_page - 1) * per_page
    verse_end = min(verse_start + per_page, manzil.last_verse_id)
    if verse_end < manzil.last_verse_id
      @next_page = current_page + 1
    end
    @total_records = manzil.verses_count

    @results = rescope_verses('verse_index')
                 .where(manzil_number: manzil.manzil_number)
                 .where('verses.verse_index >= ? AND verses.verse_index < ?', verse_start.to_i, verse_end.to_i)
  end

  def verse_pagination_start
    if (from = (params[:from] || 1).to_i.abs).zero?
      from = 1
    end

    from + (current_page - 1) * per_page
  end

  def verse_pagination_end(start, total_verses)
    to = params[:to].presence ? params[:to].to_i.abs : nil
    verse_to = min(to || total_verses, total_verses)
    params[:to] = verse_to

    min((start + per_page - 1), verse_to)
  end

  def load_words(word_translation_lang)
    language = Language.find_with_id_or_iso_code(word_translation_lang)

    words_with_default_translation = @results.where(word_translations: { language_id: Language.default.id })

    if language
      @results = @results
                   .where(word_translations: { language_id: language.id })
                   .or(words_with_default_translation)
                   .eager_load(words: eager_load_words)
    else
      @results = words_with_default_translation.eager_load(words: eager_load_words)
    end
  end

  def load_translations(translations)
    @results = @results
                 .where(translations: { resource_content_id: translations })
                 .eager_load(:translations)
  end

  def load_tafsirs(tafsirs)
    @results = @results
                 .where(tafsirs: { resource_content_id: tafsirs })
                 .eager_load(:tafsirs)
  end

  def load_audio(recitation)
    @results = @results
                 .where(audio_files: { recitation_id: recitation })
                 .eager_load(:audio_file)
  end

  def rescope_verses(by)
    Verse.unscope(:order).order("#{by} ASC")
  end
end
