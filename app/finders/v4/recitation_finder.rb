# frozen_string_literal: true

class V4::RecitationFinder < V4::VerseFinder
  attr_reader :recitation

  def load_audio(filter, recitation)
    @recitation = recitation
    load_recitation_range(filter)
  end

  protected

  def load_recitation_range(filter)
    results = send("fetch_#{filter}", recitation)
    results = results.limit(per_page)
                     .offset((current_page - 1) * per_page)
    if current_page < total_pages
      @next_page = current_page + 1
    end

    results
  end

  def fetch_by_chapter(recitation)
    chapter = validate_chapter
    @total_records = chapter.verses_count

    filter_audio_files(recitation)
      .where(chapter_id: chapter.id)
  end

  def fetch_by_page(recitation)
    results = filter_audio_files(recitation)
                .where(page_number: validate_mushaf_page_number)
    @total_records = results.size

    results
  end

  def fetch_by_rub(recitation)
    results = filter_audio_files(recitation)
                .where(rub_el_hizb_number: find_rub_el_hizb_number)
    @total_records = results.size

    results
  end

  def fetch_by_hizb(recitation)
    results = filter_audio_files(recitation)
                .where(hizb_number: find_hizb_number)
    @total_records = results.size

    results
  end

  def fetch_by_juz(recitation)
    juz = find_juz
    @total_records = juz.verses_count

    filter_audio_files(recitation)
      .where(juz_number: juz.juz_number)
  end

  def fetch_by_ruku(recitation)
    ruku = find_ruku
    @total_records = ruku.verses_count

    filter_audio_files(recitation)
      .where(ruku_number: ruku.juz_number)
  end

  def fetch_by_manzil(recitation)
    manzil = find_manzil
    @total_records = manzil.verses_count

    filter_audio_files(recitation)
      .where(manzil_number: manzil.manzil_number)
  end

  def fetch_by_ayah(recitation)
    @total_records = 1
    filter_audio_files(recitation).where(verse_id: find_ayah.id)
  end

  def filter_audio_files(recitation)
    AudioFile.where(recitation_id: recitation).order('verse_id ASC')
  end
end
