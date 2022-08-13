# frozen_string_literal: true

class Qdc::VerseFinder < ::VerseFinder
  def random_verse(filters, language_code, mushaf_id:, words: true, tafsirs: false, translations: false, reciter: false)
    mushaf = Mushaf.find(mushaf_id)
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

  def find_with_key(key, language_code, mushaf_id:, words: true, tafsirs: false, translations: false, reciter: false)
    mushaf = Mushaf.find(mushaf_id)
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

  def load_verses(filter, language_code, mushaf_id:, words: true, tafsirs: false, translations: false, reciter: false)
    mushaf = Mushaf.find(mushaf_id)
    fetch_verses_range(filter, mushaf: mushaf, words: words)

    load_related_resources(
      language: language_code,
      mushaf: mushaf,
      words: words,
      tafsirs: tafsirs,
      translations: translations,
      reciter: reciter,
      filter: filter,
      verse_order: 'filter' == filter ? '' : 'verses.verse_index ASC'
    )
  end

  def find_verses_range(filter:, mushaf:)
    # Clear the pagination and limit
    params[:page] = 1
    params[:per_page] = 'all'
    @max_records = 564 # max ayah count in juz 30

    fetch_verses_range(filter, mushaf: mushaf, words: false)
  end

  protected

  def fetch_verses_range(filter, mushaf: nil, words: false)
    # both from and to could be ayah key or ayah ID(not ayah number)
    params[:from] = get_ayah_id(params[:from])
    params[:to] = get_ayah_id(params[:to])

    if 'by_page' == filter
      @results = fetch_by_page(mushaf: mushaf, words: words)
    elsif 'by_juz' == filter
      @results = fetch_by_juz(mushaf: mushaf)
    else
      @results = send("fetch_#{filter}")
    end
  end

  def load_related_resources(language:, mushaf:, words:, tafsirs:, translations:, reciter:, filter:, verse_order: 'verses.verse_index ASC')
    load_translations(translations) if translations.present?
    load_words(language, mushaf) if words
    load_segments(reciter) if reciter
    load_tafsirs(tafsirs) if tafsirs.present?

    words_ordering = if words
                       "#{verse_order.present? ? ',' : ''} mushaf_words.position_in_verse ASC, word_translations.priority ASC"
                     else
                       ''
                     end

    translations_order = translations.present? ? "#{words_ordering.present? ? ',' : ''} translations.priority ASC" : ''
    order_query = "#{verse_order} #{words_ordering} #{translations_order}".strip

    if order_query.present?
      @results.order(order_query)
    else
      @results
    end
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
    @total_records = ids.size

    pagy = Pagy.new(
      count: @total_records,
      page: current_page,
      items: per_page,
      overflow: :empty_page
    )
    @next_page = pagy.next

    @results = if pagy.overflow?
                 Verse.none
               else
                 Verse.unscoped.where(id: ids[pagy.offset, pagy.items])
               end
  end

  def fetch_by_chapter
    chapter = find_chapter
    range = QuranUtils::Quran.get_fist_and_last_ayah_of_surah(chapter.id)
    from, to = get_ayah_range_to_load(range[0], range[1])

    @results = rescope_verses('verse_index')
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
                 .where('verses.verse_index >= ? AND verses.verse_index <= ?', from, to)
  end

  def fetch_by_hizb
    hizb = find_hizb
    from, to = get_ayah_range_to_load(hizb.first_verse_id, hizb.last_verse_id)

    @results = rescope_verses('verse_index')
                 .where('verses.verse_index >= ? AND verses.verse_index <= ?', from, to)
  end

  def fetch_by_juz(mushaf:)
    juz = find_juz(mushaf: mushaf)
    from, to = get_ayah_range_to_load(juz.first_verse_id, juz.last_verse_id)

    @results = rescope_verses('verse_index')
                 .where('verses.verse_index >= ? AND verses.verse_index <= ?', from, to)
  end

  def fetch_by_manzil
    manzil = find_manzil
    from, to = get_ayah_range_to_load(manzil.first_verse_id, manzil.last_verse_id)

    @results = rescope_verses('verse_index')
                 .where('verses.verse_index >= ? AND verses.verse_index <= ?', from, to)
  end

  def fetch_by_ruku
    ruku = find_ruku
    from, to = get_ayah_range_to_load(ruku.first_verse_id, ruku.last_verse_id)

    @results = rescope_verses('verse_index')
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
    range_start = load_verse_from(first_verse_id)
    range_end = load_verse_to(last_verse_id)

    @total_records = records_count(range_start, range_end)

    unless @total_records.positive?
      return overflow_range
    end

    pagy = Pagy.new(count: @total_records, page: current_page, items: per_page, overflow: :empty_page)
    @next_page = pagy.next

    if pagy.overflow?
      overflow_range
    else
      offset = range_start - 1
      [offset + pagy.from, offset + pagy.to]
    end
  end

  def overflow_range
    [0, 0]
  end

  def records_count(range_start, range_end)
    # `from` and `to` are inclusive in range
    (range_end - range_start) + 1
  end

  def load_verse_from(default_from)
    if params[:from].present?
      max(params[:from].to_i, default_from)
    else
      default_from
    end
  end

  def load_verse_to(default_to)
    if params[:to].present?
      min(params[:to].to_i, default_to)
    else
      default_to
    end
  end
end
