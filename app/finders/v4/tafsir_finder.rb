# frozen_string_literal: true

class V4::TafsirFinder < Finder
  attr_reader :resource_content_id

  def load_tafsirs(filter, resource_id)
    @resource_content_id = resource_id
    load_tafsir_range(filter, resource_id)
  end

  protected

  def load_tafsir_range(filter, resource_id)
    results = send("fetch_#{filter}", resource_id)

    if "by_ayah" == filter
      results = results.first
    else
      results = results.limit(per_page)
                       .offset((current_page - 1) * per_page)
    end

    if current_page < total_pages
      @next_page = current_page + 1
    end

    results
  end

  def fetch_by_chapter(resource_id)
    chapter = validate_chapter
    @total_records = chapter.verses_count
    results = filter_tafsirs(resource_id)
                .where(chapter_id: chapter.id)
    results
  end

  def fetch_by_page(resource_id)
    results = filter_tafsirs(resource_id)
                .where(page_number: validate_mushaf_page_number)
    @total_records = results.size

    results
  end

  def fetch_by_rub(resource_id)
    results = filter_tafsirs(resource_id)
                .where(rub_el_hizb_number: find_rub_el_hizb_number)
    @total_records = results.size

    results
  end

  def fetch_by_hizb(resource_id)
    results = filter_tafsirs(resource_id)
                .where(hizb_number: find_hizb_number)
    @total_records = results.size

    results
  end

  def fetch_by_juz(resource_id)
    juz = find_juz
    @total_records = juz.verses_count

    results = filter_tafsirs(resource_id)
                .where(juz_number: juz.juz_number)

    results
  end

  def fetch_by_manzil(resource_id)
    manzil = find_manzil
    @total_records = manzil.verses_count
    results = filter_tafsirs(resource_id)
                .where(manzil_number: manzil.manzil_number)

    results
  end

  def fetch_by_ruku(resource_id)
    ruku = find_ruku
    @total_records = ruku.verses_count
    results = filter_tafsirs(resource_id)
                .where(ruku_number: ruku.ruku_number)

    results
  end

  def fetch_by_ayah(resource_id)
    @total_records = 1

    filter_tafsirs(resource_id)
      .where(":ayah >= start_verse_id AND :ayah <= end_verse_id ", ayah: find_ayah.id)
  end

  def filter_tafsirs(resource_id)
    Tafsir.where(resource_content_id: resource_id).order('verse_id ASC')
  end
end
