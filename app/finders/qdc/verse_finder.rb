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

    load_related_resources(
      language: language_code,
      mushaf: mushaf,
      words: words,
      tafsirs: tafsirs,
      translations: translations,
      reciter: reciter,
      filter: filter
    )
  end

  def find_verses_range(filter:, mushaf:)
    # Clear the pagination and limit
    params[:page] = 1
    params[:per_page] = 'all'
    fetch_verses_range(filter, mushaf: mushaf, words: false)
  end

  protected

  def fetch_verses_range(filter, mushaf: nil, words: false)
    # both from and to could be ayah key or ayah ID(not ayah number)
    params[:from] = get_ayah_id(params[:from])
    params[:to] = get_ayah_id(params[:to])

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
      @results = Verse
                   .unscoped
                   .order('verses.verse_index asc')
                   .where('verses.verse_index >= :from AND verses.verse_index <= :to', from: params[:from], to: params[:to])
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
    range = QuranUtils::Quran.get_fist_and_last_ayah_of_surah(chapter.id)
    from, to = get_ayah_range_to_load(range[0], range[1])

    @results = rescope_verses('verse_index')
                 .where(chapter_id: chapter.id)
                 .where('verses.verse_index >= ? AND verses.verse_index <= ?', from, to)
  end

  def fetch_by_page(mushaf:, words:)
    mushaf_page = find_mushaf_page(mushaf: mushaf)
    from, to = get_ayah_range_to_load(mushaf_page.first_verse_id, mushaf_page.last_verse_id)
    @results = rescope_verses('verse_index').where('verses.verse_index >= ? AND verses.verse_index <= ?', from, to)

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
    from, to = get_ayah_range_to_load(rub_el_hizb.first_verse_id, rub_el_hizb.last_verse_id)

    @results = rescope_verses('verse_index')
                 .where(rub_el_hizb_number: rub_el_hizb.rub_el_hizb_number)
                 .where('verses.verse_index >= ? AND verses.verse_index <= ?', from, to)
  end

  def fetch_by_hizb
    hizb = find_hizb
    from, to = get_ayah_range_to_load(hizb.first_verse_id, hizb.last_verse_id)

    @results = rescope_verses('verse_index')
                 .where(hizb_number: hizb.hizb_number)
                 .where('verses.verse_index >= ? AND verses.verse_index <= ?', from, to)
  end

  def fetch_by_juz
    juz = find_juz
    from, to = get_ayah_range_to_load(juz.first_verse_id, juz.last_verse_id)

    @results = rescope_verses('verse_index')
                 .where(juz_number: juz.juz_number)
                 .where('verses.verse_index >= ? AND verses.verse_index <= ?', from, to)
  end

  def fetch_by_manzil
    manzil = find_manzil
    from, to = get_ayah_range_to_load(manzil.first_verse_id, manzil.last_verse_id)

    @results = rescope_verses('verse_index')
                 .where(manzil_number: manzil.manzil_number)
                 .where('verses.verse_index >= ? AND verses.verse_index <= ?', from, to)
  end

  def fetch_by_ruku
    ruku = find_ruku
    from, to = get_ayah_range_to_load(ruku.first_verse_id, ruku.last_verse_id)

    @results = rescope_verses('verse_index')
                 .where(ruku_number: ruku.ruku_number)
                 .where('verses.verse_index >= ? AND verses.verse_index <= ?', from, to)
  end

  def fetch_by_range
    from, to = get_ayah_range_to_load(params[:from], params[:to])

    @results = rescope_verses('verse_index')
                 .where('verses.verse_index >= ? AND verses.verse_index <= ?', from, to)
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

  def get_ayah_range_to_load(first_verse_id, last_verse_id)
    verse_start = load_verse_from(first_verse_id)
    verse_end = max(verse_start, load_verse_to(last_verse_id))
    @total_records = (verse_end - verse_start) + 1

    verse_start = verse_start + (current_page - 1) * per_page
    verse_start = min(verse_start, last_verse_id)

    [verse_start, min(verse_start + per_page , verse_end)]
  end

  def load_verse_from(default_from)
    if params[:from]
      max(params[:from], default_from)
    else
      default_from
    end
  end

  def load_verse_to(default_to)
    if params[:to]
      min(params[:to], default_to)
    else
      default_to
    end
  end
end
