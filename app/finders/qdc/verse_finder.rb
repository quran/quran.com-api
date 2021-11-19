# frozen_string_literal: true

class Qdc::VerseFinder < ::VerseFinder
  MAX_RECORDS_PER_PAGE = 50
  RECORDS_PER_PAGE = 10

  attr_reader :next_page,
              :total_records

  def random_verse(filters, language_code, mushaf_type:, words: true, tafsirs: false, translations: false, reciter: false)
    @results = Verse.unscope(:order).where(filters).order('RANDOM()').limit(3)

    load_related_resources(
      language: language_code,
      mushaf_type: mushaf_type,
      words: words,
      tafsirs: tafsirs,
      translations: translations,
      reciter: reciter,
      filter: :random
    ).sample
  end

  def find_with_key(key, language_code, mushaf_type:, words: true, tafsirs: false, translations: false, reciter: false)
    @results = Verse.where(verse_key: key).limit(1)

    load_related_resources(
      language: language_code,
      mushaf_type: mushaf_type,
      words: words,
      tafsirs: tafsirs,
      translations: translations,
      reciter: reciter,
      filter: :with_key
    ).first
  end

  def load_verses(filter, language_code, mushaf_type:, words: true, tafsirs: false, translations: false, reciter: false)
    fetch_verses_range(filter, mushaf_type)

    results = load_related_resources(
      language: language_code,
      mushaf_type: mushaf_type,
      words: words,
      tafsirs: tafsirs,
      translations: translations,
      reciter: reciter,
      filter: filter
    )

    if 'by_page' == filter
      #
      # NOTE: in 16 lines mushaf ayahs could span into multiple pages
      # and we need to restrict words that are on requested page.
      # TODO: allow clients to choose if they want all words of ayah or only words for page
      # for now, returning whole ayah
      # .where(mushaf_words: {page_number: params[:page_number].to_i})
      results
    else
      results
    end
  end

  def per_page
    strong_memoize :per_page do
      if params[:per_page].to_s.strip == 'all'
        total_records
      else
        limit = (params[:per_page] || RECORDS_PER_PAGE).to_i.abs
        limit = RECORDS_PER_PAGE if limit.zero?
        MAX_RECORDS_PER_PAGE ? limit : RECORDS_PER_PAGE
      end
    end
  end

  def total_pages
    (total_records / per_page.to_f).ceil
  end

  protected

  def fetch_verses_range(filter, mushaf_type)
    if 'by_page' == filter
      @results = fetch_by_page(mushaf_id: mushaf_type)
    else
      @results = send("fetch_#{filter}")
    end
  end

  def load_related_resources(language:, mushaf_type:, words:, tafsirs:, translations:, reciter:, filter:)
    load_translations(translations) if translations.present?
    load_words(language, mushaf_type) if words
    load_segments(reciter) if reciter
    load_tafsirs(tafsirs) if tafsirs.present?

    words_ordering = if words
                       if filter.to_s == 'by_page'
                         'mushaf_words.position_in_page ASC, word_translations.priority ASC, '
                       else
                         'mushaf_words.position_in_verse ASC, word_translations.priority ASC, '
                       end
                     else
                       ''
                     end

    translations_order = translations.present? ? 'translations.priority ASC, ' : ''
    @results.order("#{words_ordering} #{translations_order} verses.verse_index ASC".strip)
  end

  def fetch_advance_copy
    fetch_range
  end

  def fetch_range
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
    @results = results.limit(per_page).offset((current_page - 1) * per_page)

    if current_page < total_pages
      @next_page = current_page + 1
    end

    @results
  end

  def fetch_by_chapter
    if chapter = find_chapter(params[:chapter_number])
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
    else
      @total_records = 0
      @next_page = nil
      @results = Verse.none
    end

    @results
  end

  def fetch_by_page(mushaf_id:)
    if mushaf_page = MushafPage.where(mushaf_id: mushaf_id, page_number: params[:page_number].to_i.abs).first
      verse_start = mushaf_page.first_verse_id
      verse_end = mushaf_page.last_verse_id
      @results = rescope_verses('verse_index').where('verses.verse_index >= ? AND verses.verse_index <= ?', verse_start, verse_end)

      # Disable pagination for by_page route
      @next_page = nil
      @total_records = @results.size
      @per_page = @total_records
    else
      @total_records = 0
      @next_page = nil
      @results = Verse.where('1=0')
    end

    @results
  end

  def fetch_by_rub
    results = rescope_verses('verse_index')
                .where(rub_number: params[:rub_number].to_i.abs)

    @total_records = results.size
    @results = results.limit(per_page).offset((current_page - 1) * per_page)

    if current_page < total_pages
      @next_page = current_page + 1
    end

    @results
  end

  def fetch_by_hizb
    results = rescope_verses('verse_index')
                .where(hizb_number: params[:hizb_number].to_i.abs)

    @total_records = results.size
    @results = results.limit(per_page).offset((current_page - 1) * per_page)

    if current_page < total_pages
      @next_page = current_page + 1
    end

    @results
  end

  def fetch_by_juz
    if juz = Juz.find_by(juz_number: params[:juz_number].to_i.abs)
      @total_records = juz.verses_count

      verse_start = juz.first_verse_id + (current_page - 1) * per_page
      verse_end = min(verse_start + per_page, juz.last_verse_id)

      if verse_end < juz.last_verse_id
        @next_page = current_page + 1
      end

      @results = rescope_verses('verse_index')
                   .where(juz_number: juz.juz_number)
                   .where('verses.verse_index >= ? AND verses.verse_index < ?', verse_start.to_i, verse_end.to_i)
    else
      @total_records = 0
      Verse.where('1=0')
    end
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

  def load_words(word_translation_lang, mushaf_type)
    language = Language.find_with_id_or_iso_code(word_translation_lang)

    @results = @results.where(mushaf_words: { mushaf_id: mushaf_type })
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

  def find_chapter(id_or_slug)
    strong_memoize :_chapter do
      Chapter.find_using_slug(id_or_slug)
    end
  end

  def eager_load_words
    [:word_translation, :word]
  end
end
