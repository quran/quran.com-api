# frozen_string_literal: true

require 'cld3'

module Search
  class Query
    attr_reader :query # rubocop:disable
    include QuranUtils::StrongMemoize

    LANG_DETECTOR_CLD3 = CLD3::NNetLanguageIdentifier.new(0, 2000)
    REGEXP_AYAH_RANGE = /^(?<surah>\d+)[\s\/:-]+(?<from>\d+)[\s\/:-]+(?<to>\d+)$/
    REGEXP_AYAH_KEY = /^(?<surah>\d+)[\/:\\](?<ayah>\d+)$/

    def initialize(query)
      @query = query.to_s.strip
    end

    def arabic?
      detect_languages.include? 'ar'
    end

    def only_arabic?
      detect_languages == ['ar']
    end

    def is_ayah_key_query?
      REGEXP_AYAH_KEY.match query
    end

    def is_range_query?
      REGEXP_AYAH_RANGE.match query
    end

    def detect_languages
      strong_memoize :detected_langs do
        LANG_DETECTOR_CLD3.find_top_n_most_freq_langs(query.to_s, 5).map do |part|
          part.language.to_s
        end
      end
    end

    def detect_language_code
      return @detect_language if @detect_language

      detected_lang = LANG_DETECTOR_CLD3.find_language(query)
      @detect_language = detected_lang.language
    rescue StandardError
    end
  end
end