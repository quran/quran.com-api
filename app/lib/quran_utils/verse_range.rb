# frozen_string_literal: true

module QuranUtils
  class VerseRange
    RANGE_REG = /(?<chapter>\d+):?(?<from>\d+)?-?(?<to>\d+)?/

    def initialize(range)
      @range = range
    end

    def get_ids
      ids = []
      chapter, from, to = process_range

      if chapter
        if from
          from.to_i.upto(to.to_i) do |ayah|
            ids << QuranUtils::Quran.get_ayah_id_from_key("#{chapter}:#{ayah}")
          end
        else
          ids << chapter
        end
      end

      ids
    end

    protected
    def process_range
      match = @range.match(RANGE_REG)

      return [] if match.nil?

      chapter = match[:chapter]
      from = match[:from]
      to = match[:to] || from

      [chapter, from, to]
    end
  end
end
