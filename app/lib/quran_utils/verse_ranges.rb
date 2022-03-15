# frozen_string_literal: true

module QuranUtils
  class VerseRanges
    def get_ids_from_ranges(ranges)
      ranges = ranges.to_s.split(',').compact_blank
      ids = []

      if ranges.present?
        ids = ranges.map do |range|
          QuranUtils::VerseRange.new(range).get_ids
        end

        ids.flatten.uniq
      else
        ids
      end
     end
  end
end
