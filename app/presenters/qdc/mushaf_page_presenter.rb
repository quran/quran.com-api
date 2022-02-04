module Qdc
  class MushafPagePresenter < BasePresenter
    def pages
      MushafPage.where(mushaf_id: get_mushaf_id).order('page_number ASC')
    end

    def page
      MushafPage.where(mushaf_id: get_mushaf_id).find_by_page_number(params[:id]) || raise_404("Invalid page number")
    end

    # Find pages based on given filters and Mushaf
    def lookup
      filter = look_up_filter
      filters = lookup_verse_range(filter)

      if filters.present?
        if 'by_page' == filter
          pages.where('(first_verse_id >= :verse_from) AND (last_verse_id <= :verse_to)', filters)
        else
          pages.where('(first_verse_id >= :verse_from OR last_verse_id >= :verse_from) AND (first_verse_id <= :verse_to OR last_verse_id <= :verse_to)', filters)
        end
      else
        []
      end
    end

    def lookup_range_keys
      range = lookup_verse_range

      {
        from: QuranUtils::Quran.get_ayah_key_from_id(range[:verse_from]),
        to: QuranUtils::Quran.get_ayah_key_from_id(range[:verse_to])
      }
    end

    def filtered_lookup_range_for_page(page)
      range = lookup_verse_range
      from = QuranUtils::Quran.get_ayah_key_from_id([page.first_verse_id, range[:verse_from]].max)
      to = QuranUtils::Quran.get_ayah_key_from_id([page.last_verse_id, range[:verse_to]].min)

      {
        from: from,
        to: to
      }
    end

    protected

    def lookup_verse_range(filter=nil)
      filter ||= look_up_filter

      strong_memoize :lookup_range do
        finder = ::Qdc::VerseFinder.new(params)
        verses = finder.find_verses_range(
          filter: filter,
          mushaf: get_mushaf
        )

        if verses.first
          {
            verse_from: verses.first&.id,
            verse_to: verses.last&.id
          }
        end
      end
    end

    def get_ayah_id(ayah_id_or_key)
      if ayah_id_or_key.present? && ayah_id_or_key.include?(':')
        QuranUtils::Quran.get_ayah_id_from_key(ayah_id_or_key)
      else
        ayah_id_or_key.presence
      end
    end

    def look_up_filter
      strong_memoize :filter_name do
        if params[:chapter_number].present?
          'by_chapter'
        elsif params[:juz_number].present?
          'by_juz'
        elsif params[:page_number].present?
          'by_page'
        elsif params[:manzil_number].present?
          'by_manzil'
        elsif params[:rub_el_hizb_number].present?
          'by_rub_el_hizb'
        elsif params[:hizb_number].present?
          'by_hizb'
        elsif params[:ruku_number].present?
          'ruku_number'
        else
          raise_404 "Look up filter is invalid, please provide a valid filter(chapter_number, juz_number, page_number, manzil_number, rub_el_hizb_number, hizb_number, ruku_number)"
        end
      end
    end
  end
end