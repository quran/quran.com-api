# frozen_string_literal: true

class V4::TafsirFinder < V4::VerseFinder
  attr_reader :resource_content_id

  def load_tafsirs(filter, resource_id)
    @resource_content_id = resource_id
    load_tafsir_range(filter, resource_id)
  end

  protected

  def load_tafsir_range(filter, resource_id)
    results = send("fetch_#{filter}", resource_id)

    results = results.limit(per_page)
                  .offset((current_page - 1) * per_page)

    if current_page < total_pages
      @next_page = current_page + 1
    end

    results
  end

  def fetch_by_chapter(resource_id)
    if chapter = Chapter.find_by(id: params[:chapter_number].to_i.abs)
      @total_records = chapter.verses_count
      results = filter_tafsirs(resource_id)
                    .where(chapter_id: params[:chapter_number].to_i.abs)
    else
      results = Tafsir.where('1=0')
    end

    results
  end

  def fetch_by_page(resource_id)
    results = filter_tafsirs(resource_id)
                  .where(page_number: params[:page_number].to_i.abs)

    @total_records = results.size

    results
  end

  def fetch_by_rub(resource_id)
    results = filter_tafsirs(resource_id)
                  .where(rub_number: params[:rub_number].to_i.abs)

    @total_records = results.size

    results
  end

  def fetch_by_hizb(resource_id)
    results = filter_tafsirs(resource_id)
                  .where(hizb_number: params[:hizb_number].to_i.abs)

    @total_records = results.size
    results
  end

  def fetch_by_juz(resource_id)
    if juz = Juz.find_by_juz_number(params[:juz_number].to_i.abs)
      @total_records = juz.verses_count

      results = filter_tafsirs(resource_id)
                    .where(juz_number: juz.juz_number)

      results
    else
      Tafsir.where('1=0')
    end
  end

  def fetch_by_ayah(resource_id)
    @total_records = 1
    filter_tafsirs(resource_id).where(verse_key: params[:ayah_key])
  end

  def filter_tafsirs(resource_id)
    Tafsir.where(resource_content_id: resource_id).order('verse_id ASC')
  end
end