# frozen_string_literal: true

require 'cld3'
module Qdc
  module Search
    class Query
      attr_reader :query # rubocop:disable

      LANG_DETECTOR_CLD3 = CLD3::NNetLanguageIdentifier.new(0, 2000)

      def initialize(query)
        @query = query.to_s.force_encoding('ASCII-8BIT')
                      .strip
      end

      def arabic?
        detect_language_code == :ar
      end

      def has_ayah_key?
        query.match? /[\/:\\]/
      end

      def detect_languages
        LANG_DETECTOR_CLD3.find_top_n_most_freq_langs(query.to_s, 5).map do |part|
          part.language.to_s
        end
      end

      def detect_language_code
        return @detect_language if @detect_language

        detected_lang = LANG_DETECTOR_CLD3.find_language(query)
        @detect_language = detected_lang.language
      rescue StandardError
      end

      def language_match
        @query.prose
      end
    end
  end
end