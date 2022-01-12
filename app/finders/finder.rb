class Finder
  include QuranUtils::StrongMemoize
  attr_reader :params,
              :results,
              :next_page,
              :total_records

  MAX_RECORDS_PER_PAGE = 50
  RECORDS_PER_PAGE = 10

  def initialize(params)
    @params = params
  end

  def per_page
    limit = (params[:limit] || 10).to_i.abs
    limit = 10 if limit.zero?

    limit <= 50 ? limit : 50
  end

  def next_page
    if last_page?
      return nil
    end

    current_page + 1
  end

  def prev_page
    current_page - 1 unless first_page?
  end

  def first_page?
    current_page == 1
  end

  def last_page?
    current_page == total_pages
  end

  def current_page
    strong_memoize :current_page do
      (params[:page].to_i <= 1 ? 1 : params[:page].to_i)
    end
  end

  def total_pages
    (total_records / per_page.to_f).ceil
  end

  def total_verses
    chapter.verses_count
  end

  protected

  def validate_mushaf_page_number
    page = params[:page_number].to_i.abs

    if page >= 1 && page <= 604
      page
    else
      raise_invalid_mushaf_page_number
    end
  end

  def find_rub_number
    rub_el_hizb_number = params[:rub_el_hizb_number].to_i.abs

    if rub_el_hizb_number >= 1 && rub_el_hizb_number <= 240
      rub_el_hizb_number
    else
      raise_invalid_rub_number
    end
  end

  def find_hizb_number
    hizb_nunber = params[:hizb_number].to_i.abs

    if hizb_nunber >= 1 && hizb_number <= 60
      hizb_nunber
    else
      raise_invalid_hizb_number
    end
  end

  def find_manzil
    manzil_number = params[:manzil_number].to_i.abs

    if manzil_number >= 1 && manzil_number <= 7
      Manzil.find_by(manzil_number: manzil_number)
    else
      raise_invalid_manzil_number
    end
  end

  def find_ruku
    params[:ruku_number]
    raise_invalid_ruku_number
  end

  def find_juz
    juz_nunber = params[:juz_number].to_i.abs

    if juz_nunber >= 1 && juz_nunber <= 30
      Juz.find_by(juz_nunber: juz_nunber)
    else
      raise_invalid_juz_number
    end
  end

  def find_ayah
    Verse.find_by_id_or_key(params[:ayah_key].to_s) || raise_invalid_ayah_number
  end

  def validate_chapter(id_or_slug=nil)
    id_or_slug ||= params[:chapter_number].to_s.strip

    Chapter.find_using_slug(id_or_slug) || raise_invalid_surah_number
  end

  def min(a, b)
    a < b ? a : b
  end

  def max(a, b)
    a > b ? a : b
  end

  def raise_invalid_ayah_number

  end

  def raise_invalid_surah_number
    raise(RestApi::RecordNotFound.new("Surah not found. Please select valid slug or surah number from 1-114"))
  end

  def raise_invalid_juz_number
    raise(RestApi::RecordNotFound.new("Juz not found. Please select valid juz number from 1-30."))
  end

  def raise_invalid_manzil_number

  end

  def raise_invalid_hizb_number
    raise RestApi::RecordNotFound.new("Hizb not found. Please select valid hizb number from 1-60.")
  end

  def raise_invalid_rub_number
    raise RestApi::RecordNotFound.new("R not found. Please select valid hizb number from 1-60.")
  end

  def raise_invalid_mushaf_page_number

  end

  def raise_invalid_ruku_number

  end
end