# frozen_string_literal: true

class Qdc::VerseFinder < ::VerseFinder
  # For some apis we need to return results in a specific order
  # those apis can define order in `verses_fixed_order`
  attr_reader :verses_fixed_order

  def random_verse(filters, language_code, mushaf_id:, words: true, tafsirs: false, translations: false, reciter: false)
    mushaf = Mushaf.find(mushaf_id)
    @results = Verse.unscope(:order).where(filters).order('RANDOM()').limit(3)

    load_related_resources(
      language: language_code,
      mushaf: mushaf,
      words: words,
      tafsirs: tafsirs,
      translations: translations,
      reciter: reciter
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
      reciter: reciter
    ).first
  end

  def load_verses(filter, language_code, mushaf_id:, words: true, tafsirs: false, translations: false, reciter: false)
    mushaf = Mushaf.find(mushaf_id)
    fetch_verses_range(filter, mushaf: mushaf, words: words)

    records = load_related_resources(
      language: language_code,
      mushaf: mushaf,
      words: words,
      tafsirs: tafsirs,
      translations: translations,
      reciter: reciter
    )

    if verses_fixed_order.present?
      fix_verses_order(records)
    else
      records
    end
  end

  def find_verses_range(filter:, mushaf:)
    # Clear the pagination and limit
    params[:page] = 1
    params[:per_page] = 'all'
    @max_records = 564 # max ayah count in juz 30

    fetch_verses_range(filter, mushaf: mushaf, words: false)
  end

  protected

  # for verses based on specified order
  def fix_verses_order(verses)
    lookup = {}
    verses_fixed_order.each_with_index do |verse_id, index|
      lookup[verse_id] = index
    end

    verses.sort_by do |verse|
      lookup[verse.id]
    end
  end

  def fetch_verses_range(filter, mushaf: nil, words: false)
    if 'by_range' == filter
      @results = fetch_by_range
    else
      # TODO: we need to validate from and to before passing it to get_ayah_id. Currently "from"=>"testFrom:1", "to"=>"testTo:5" gets converted to "from"=>6231, "to"=>6235. {@see fetch_by_range}
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
  end

  def load_related_resources(language:, mushaf:, words:, tafsirs:, translations:, reciter:)
    load_translations(translations) if translations.present?
    load_words(language, mushaf) if words.present?
    load_segments(reciter) if reciter.present?
    load_tafsirs(tafsirs) if tafsirs.present?

    # TODO: move ordering to separate method
    order_clauses = []
    if words
      order_clauses << "mushaf_words.position_in_verse ASC, word_translations.priority ASC"
    end

    order_clauses << 'translations.priority ASC' if translations.present?
    order_query = order_clauses.join(',').strip

    if order_query.present?
      @results.order(Arel.sql(order_query))
    else
      @results
    end
  end

  def fetch_advance_copy
    if params[:from] && params[:to]
      @results = rescope_verses('verse_index')
                   .where('verses.verse_index >= :from AND verses.verse_index <= :to', from: params[:from], to: params[:to])
    else
      @results = Verse.none
    end

    @results
  end

  def fetch_filter
    utils = QuranUtils::VerseRanges.new
    ids = utils.get_ids_from_ranges(params[:filters])
    @verses_fixed_order = ids
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
    @results = rescope_verses('verse_index')
                 .where('verses.verse_index >= ? AND verses.verse_index <= ?', from, to)

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
    # 1. make sure both from and to are present
    raise(RestApi::RecordNotFound.new("From and to must be present.")) unless params[:from] && params[:to]
    from_range = QuranUtils::VerseKey.new(params[:from])
    from_verse_key_data = from_range.process_verse_key
    to_range = QuranUtils::VerseKey.new(params[:to])
    to_verse_key_data = to_range.process_verse_key
    # 2. make sure from and to are in the format of 'chapter:verse' e.g. don't accept from=test&to=anotherTest
    raise(RestApi::RecordNotFound.new("Verse key contains invalid data")) if from_verse_key_data.empty? || to_verse_key_data.empty?
    # 3. make sure from and to have both chapter and verse. e.g. don't allow testFrom:1&to=testTo:5
    raise(RestApi::RecordNotFound.new("Verse key contains invalid data")) unless from_verse_key_data.all? && to_verse_key_data.all?
    params[:from] = get_ayah_id(params[:from])
    params[:to] = get_ayah_id(params[:to])
    # 4. make sure from and to Ids are not nil. Either can be nil if the verse key contains out of range values e.g. 1:8 or 500:1
    raise(RestApi::RecordNotFound.new("Verse key contains out of range values")) if params[:from].nil? || params[:to].nil?
    # 5. make sure from is smaller than to. An invalid range e.g. from=1:7&to=1:4
    raise(RestApi::RecordNotFound.new("From should be smaller than to")) if params[:from] > params[:to]
    from, to = get_ayah_range_to_load(params[:from], params[:to])
    @results = rescope_verses('verse_index').where('verses.verse_index >= ? AND verses.verse_index <= ?', from, to)
  end

  def load_words(word_translation_lang, mushaf)
    language = Language.find_with_id_or_iso_code(word_translation_lang)

    @results = @results.where(mushaf_words: { mushaf_id: mushaf.id })
    approved_word_by_word_translations = ResourceContent.approved.one_word.translations
    words_with_default_translation = @results.where(word_translations: { language_id: Language.default.id, resource_content_id: approved_word_by_word_translations })

    if language.nil? || language.default?
      @results = words_with_default_translation.eager_load(mushaf_words: eager_load_words)
    else
      @results = @results
                   .where(word_translations: { language_id: language.id, resource_content_id: approved_word_by_word_translations })
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
