# frozen_string_literal: true

class Qdc::VerseFinder < ::VerseFinder
  def random_verse(filters, language_code, mushaf_type:, words: true, tafsirs: false, translations: false, reciter: false)
    mushaf = Mushaf.find(mushaf_type)
    @results = Verse.unscope(:order).where(filters).order('RANDOM()').limit(3)

    load_related_resources(
      language: language_code,
      mushaf: mushaf,
      words: words,
      tafsirs: tafsirs,
      translations: translations,
      reciter: reciter,
      filter: :random
    ).sample
  end

  def find_with_key(key, language_code, mushaf_type:, words: true, tafsirs: false, translations: false, reciter: false)
    mushaf = Mushaf.find(mushaf_type)
    @results = Verse.where(verse_key: key).limit(1)

    load_related_resources(
      language: language_code,
      mushaf: mushaf,
      words: words,
      tafsirs: tafsirs,
      translations: translations,
      reciter: reciter,
      filter: :with_key
    ).first
  end

  def load_verses(filter, language_code, mushaf_type:, words: true, tafsirs: false, translations: false, reciter: false)
    mushaf = Mushaf.find(mushaf_type)

    fetch_verses_range(filter, mushaf: mushaf, words: words)

    results = load_related_resources(
      language: language_code,
      mushaf: mushaf,
      words: words,
      tafsirs: tafsirs,
      translations: translations,
      reciter: reciter,
      filter: filter
    )

    results
  end

  def find_verses_range(filter:, mushaf:, from: nil, to: nil)
    # Clear the pagination and range(from, to) filter
    params[:from] = nil
    params[:to] = nil
    params[:page] = 1
    params[:per_page] = 'all'
    verses = fetch_verses_range(filter, mushaf: mushaf, words: false)

    if from.present?
      verses = verses.where('verses.id >= ?', from)
    end

    if to.present?
      verses = verses.where('verses.id <= ?', to)
    end

    verses
  end

  protected

  def fetch_verses_range(filter, mushaf: nil, words: false)
    if 'by_page' == filter
      @results = fetch_by_page(mushaf: mushaf, words: words)
    else
      @results = send("fetch_#{filter}")
    end
  end

  def load_related_resources(language:, mushaf:, words:, tafsirs:, translations:, reciter:, filter:)
    load_translations(translations) if translations.present?
    load_words(language, mushaf) if words
    load_segments(reciter) if reciter
    load_tafsirs(tafsirs) if tafsirs.present?

    words_ordering = if words
                       ', mushaf_words.position_in_verse ASC, word_translations.priority ASC'
                     else
                       ''
                     end

    translations_order = translations.present? ? ', translations.priority ASC' : ''
    @results.order("verses.verse_index ASC #{words_ordering} #{translations_order}".strip)
  end

  def fetch_advance_copy
    if params[:from] && params[:to]
      verse_from = QuranUtils::Quran.get_ayah_id_from_key(params[:from])
      verse_to = QuranUtils::Quran.get_ayah_id_from_key(params[:to])

      @results = Verse
                   .unscoped
                   .order('verses.verse_index asc')
                   .where('verses.verse_index >= :from AND verses.verse_index <= :to', from: verse_from, to: verse_to)
    else
      @results = Verse.none
    end

    @results
  end

  def fetch_filter
    utils = QuranUtils::VerseRanges.new
    ids = utils.get_ids_from_ranges(params[:filters])
    results = Verse.unscoped.where(id: ids)
    @total_records = results.size

    if per_page == @total_records
      @results = results
      @next_page = nil # disable pagination
    else
      @results = results.limit(per_page).offset((current_page - 1) * per_page)

      if current_page < total_pages
        @next_page = current_page + 1
      end
    end

    @results
  end

  def fetch_by_chapter
    chapter = find_chapter

    if params[:from].present?
      verse_from = params[:from].to_i
    else
      verse_from = 1
    end

    if params[:to].present?
      verse_to = params[:to].to_i
    else
      verse_to = chapter.verses_count
    end

    @total_records = max(0, (verse_to == verse_from) ? 1 : (verse_to + 1) - verse_from)
    verse_start = verse_pagination_start
    verse_end = verse_pagination_end(verse_start, chapter.verses_count)

    @next_page = current_page + 1 if verse_end < params[:to]

    @results = Verse
                 .where(chapter_id: chapter.id)
                 .where('verses.verse_number >= ? AND verses.verse_number <= ?', verse_start.to_i, verse_end.to_i)
  end

  def fetch_by_page(mushaf:, words:)
    mushaf_page = find_mushaf_page(mushaf: mushaf)
    # Disable pagination for by_page route
    @next_page = nil
    @per_page = @total_records = mushaf_page.verses_count

    verse_start = mushaf_page.first_verse_id
    verse_end = mushaf_page.last_verse_id
    @results = rescope_verses('verse_index').where('verses.verse_index >= ? AND verses.verse_index <= ?', verse_start, verse_end)

    only_page_words = params[:filter_page_words] == 'true'
    if words && mushaf.lines_per_page == 16 && only_page_words
      # NOTE: in 16 lines mushaf ayahs could span into multiple pages
      # and we need to restrict words that are on requested page.
      @results = @results.where(mushaf_words: { page_number: mushaf_page.page_number })
    else
      @results
    end
  end

  def fetch_by_rub_el_hizb
    rub_el_hizb = find_rub_el_hizb
    # Disable pagination for rub_el_hizb route
    @next_page = nil
    @per_page = @total_records = rub_el_hizb.verses_count

    @results = rescope_verses('verse_index')
                 .where(rub_el_hizb_number: rub_el_hizb.rub_el_hizb_number)
  end

  def fetch_by_hizb
    hizb = find_hizb
    results = rescope_verses('verse_index')
                .where(hizb_number: hizb.hizb_number)

    @total_records = results.size

    if @total_records == per_page
      @next_page = nil # disable pagination
      @results = results
    else
      if current_page < total_pages
        @next_page = current_page + 1
      end

      @results = results.limit(per_page).offset((current_page - 1) * per_page)
    end
  end

  def fetch_by_juz
    juz = find_juz
    @total_records = juz.verses_count

    verse_start = juz.first_verse_id + (current_page - 1) * per_page
    verse_end = min(verse_start + per_page, juz.last_verse_id)

    if verse_end < juz.last_verse_id
      @next_page = current_page + 1
    end

    @results = rescope_verses('verse_index')
                 .where(juz_number: juz.juz_number)
                 .where('verses.verse_index >= ? AND verses.verse_index < ?', verse_start.to_i, verse_end.to_i)
  end

  def fetch_by_manzil
    manzil = find_manzil
    @total_records = manzil.verses_count

    verse_start = manzil.first_verse_id + (current_page - 1) * per_page
    verse_end = min(verse_start + per_page, manzil.last_verse_id)

    if verse_end < manzil.last_verse_id
      @next_page = current_page + 1
    end

    @results = rescope_verses('verse_index')
                 .where(manzil_number: manzil.manzil_number)
                 .where('verses.verse_index >= ? AND verses.verse_index < ?', verse_start.to_i, verse_end.to_i)
  end

  def fetch_by_ruku
    ruku = find_ruku
    # Disable pagination for ruku route
    @next_page = nil
    @per_page = @total_records = ruku.verses_count

    @results = rescope_verses('verse_index').where(ruku_number: ruku.ruku_number)
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

  def load_words(word_translation_lang, mushaf)
    language = Language.find_with_id_or_iso_code(word_translation_lang)

    @results = @results.where(mushaf_words: { mushaf_id: mushaf.id })
    words_with_default_translation = @results.where(word_translations: { language_id: Language.default.id })

    if language.nil? || language.default?
      @results = words_with_default_translation.eager_load(mushaf_words: eager_load_words)
    else
      @results = @results
                   .where(word_translations: { language_id: language.id })
                   .or(words_with_default_translation)
                   .eager_load(mushaf_words: eager_load_words)
    end
  end

  def load_segments(reciter)
    @results = @results
                 .where(audio_segments: { audio_recitation_id: reciter })
                 .eager_load(:audio_segment)
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

  def eager_load_words
    [:word_translation, :word]
  end
end
