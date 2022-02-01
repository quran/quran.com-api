class Finder
  include QuranUtils::StrongMemoize
  attr_reader :params,
              :results,
              :next_page,
              :total_records

  MAX_RECORDS_PER_PAGE = 50
  RECORDS_PER_PAGE = 10

  def initialize(params = {})
    @params = params
  end

  def per_page
    strong_memoize :per_page do
      items_per_page = (params[:limit].presence || params[:per_page]).to_s.strip
      if items_per_page.to_s.strip == 'all'
        [total_records || total_verses, max_records].min
      else
        limit = (items_per_page.presence || RECORDS_PER_PAGE).to_i.abs
        limit = RECORDS_PER_PAGE if limit.zero?
        MAX_RECORDS_PER_PAGE ? limit : RECORDS_PER_PAGE
      end
    end
  end

  def max_records
    @max_records || 286
  end

  def next_page
    if last_page?
      return nil
    end

    @next_page || current_page + 1
  end

  def prev_page
    current_page - 1 unless first_page?
  end

  def first_page?
    current_page == 1
  end

  def last_page?
    total_pages <= 1 || current_page == total_pages
  end

  def current_page
    strong_memoize :current_page do
      page = params[:page].to_i

      page.positive? ? page : 1
    end
  end

  def total_pages
    strong_memoize :total_pages do
      if total_records.zero? || per_page.zero?
        0
      else
        (total_records / per_page.to_f).ceil
     end
    end
  end

  def total_verses
    chapter.verses_count
  end

  protected

  def find_mushaf_page(mushaf: nil)
    mushaf ||= Mushaf.default
    page_number = params[:page_number].to_i.abs
    mushaf_page = MushafPage.where(mushaf_id: mushaf.id, page_number: page_number).first

    mushaf_page || raise_invalid_mushaf_page_number
  end

  def find_rub_el_hizb
    number = params[:rub_el_hizb_number].to_i.abs

    RubElHizb.find_by(rub_el_hizb_number: number) || raise_invalid_rub_el_hizb_number
  end

  def find_hizb
    hizb_number = params[:hizb_number].to_i.abs

    Hizb.find_by(hizb_number: hizb_number) || raise_invalid_hizb_number
  end

  def find_manzil
    manzil_number = params[:manzil_number].to_i.abs

    Manzil.find_by(manzil_number: manzil_number) || raise_invalid_manzil_number
  end

  def find_ruku
    ruku_number = params[:ruku_number].to_i.abs
    Ruku.find_by(ruku_number: ruku_number) || raise_invalid_ruku_number
  end

  def find_juz
    juz_number = params[:juz_number].to_i.abs

    Juz.find_by(juz_number: juz_number) || raise_invalid_juz_number
  end

  def find_ayah
    Verse.find_by_id_or_key(params[:ayah_key].to_s) || raise_invalid_ayah_number
  end

  def find_chapter(id_or_slug = nil)
    id_or_slug = (id_or_slug.presence || params[:chapter_number] || params[:chapter_id]).to_s.strip

    Chapter.find_using_slug(id_or_slug) || raise_invalid_surah_number
  end

  def min(a, b)
    a < b ? a : b
  end

  def max(a, b)
    a > b ? a : b
  end

  def raise_invalid_ayah_number
    raise(RestApi::RecordNotFound.new("Ayah key or ID is invalid. Please select valid ayah key(1:1 to 114:6) or ID(1 to 6236)."))
  end

  # Convert the input into ayah id. Input could be ayah or or simple integer value
  def get_ayah_id(ayah_id_or_key)
    return if ayah_id_or_key.blank?

    id = if ayah_id_or_key.present? && ayah_id_or_key.include?(':')
           QuranUtils::Quran.get_ayah_id_from_key(ayah_id_or_key)
         else
           ayah_id_or_key.to_i
         end

    id.positive? ? id : nil
  end

  def raise_invalid_surah_number
    raise(RestApi::RecordNotFound.new("Surah number or slug is invalid. Please select valid slug or surah number from 1-114."))
  end

  def raise_invalid_juz_number
    raise(RestApi::RecordNotFound.new("Juz number is invalid. Please select valid juz number from 1-30."))
  end

  def raise_invalid_manzil_number
    raise(RestApi::RecordNotFound.new("Manzil number is invalid. Please select valid manzil number from 1-7."))
  end

  def raise_invalid_hizb_number
    raise RestApi::RecordNotFound.new("Hizb number is invalid. Please select valid hizb number from 1-60.")
  end

  def raise_invalid_rub_el_hizb_number
    raise RestApi::RecordNotFound.new("Rub el hizb number is invalid. Please select valid rub el hizb number from 1-240.")
  end

  def raise_invalid_mushaf_page_number
    raise RestApi::RecordNotFound.new("Mushaf page number is invalid. Please select valid page from 1-604.")
  end

  def raise_invalid_ruku_number
    raise RestApi::RecordNotFound.new("R not found. Please select valid hizb number from 1-60.")
  end
end