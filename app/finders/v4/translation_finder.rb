# frozen_string_literal: true

class V4::TranslationFinder < Finder
  attr_reader :resource_content_id

  def load_translations(filter, resource_id)
    @resource_content_id = resource_id

    load_translate_range(filter, resource_id)
  end

  protected

  def load_translate_range(filter, resource_id)
    results = send("fetch_#{filter}", resource_id)
    results = results.limit(per_page)
                     .offset((current_page - 1) * per_page)
    if current_page < total_pages
      @next_page = current_page + 1
    end

    results
  end

  def fetch_by_chapter(resource_id)
    chapter = find_chapter
    @total_records = chapter.verses_count

    filter_translations(resource_id)
      .where(chapter_id: chapter.id)
  end

  def fetch_by_page(resource_id)
    mushaf_page = find_mushaf_page
    @total_records = mushaf_page.verses_count

    filter_translations(resource_id)
      .where(page_number: mushaf_page.page_number)
  end

  def fetch_by_rub_el_hizb(resource_id)
    rub_el_hizb = find_rub_el_hizb
    @total_records = rub_el_hizb.verses_count

    filter_translations(resource_id)
      .where(rub_el_hizb_number: rub_el_hizb.rub_el_hizb_number)
  end

  def fetch_by_hizb(resource_id)
    hizb = find_hizb
    @total_records = hizb.verses_count

    filter_translations(resource_id)
                .where(hizb_number: hizb.hizb_number)
  end

  def fetch_by_juz(resource_id)
    juz = find_juz
    @total_records = juz.verses_count

    filter_translations(resource_id)
      .where(juz_number: juz.juz_number)
  end

  def fetch_by_ruku(resource_id)
    ruku = find_ruku
    @total_records = ruku.verses_count

    filter_translations(resource_id)
      .where(ruku_number: ruku.ruku_number)
  end

  def fetch_by_manzil(resource_id)
    manzil = find_manzil
    @total_records = manzil.verses_count

    filter_translations(resource_id)
      .where(manzil_number: manzil.manzil_number)
  end

  def fetch_by_ayah(resource_id)
    @total_records = 1

    filter_translations(resource_id).where(verse_id: find_ayah.id)
  end

  def filter_translations(resource_id)
    Translation.where(resource_content_id: resource_id).order('verse_id ASC')
  end
end
