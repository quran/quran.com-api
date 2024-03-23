# frozen_string_literal: true

module QuranUtils
  class VerseKey
    include QuranUtils::StrongMemoize
    VERSE_KEY_REGEX = /(?<chapter>\d+):?(?<verse>\d+)?/

    def initialize(verse_key)
      @verse_key = verse_key
    end

    def process_verse_key
      strong_memoize :process_verse_key do
        match = @verse_key.match(VERSE_KEY_REGEX)

        return [] if match.nil?

        chapter = match[:chapter]
        verse = match[:verse]

        [chapter, verse]
      end
    end
  end
end
