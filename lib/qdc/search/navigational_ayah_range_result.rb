# frozen_string_literal: true

module Qdc
  module Search
    class NavigationalAyahRangeResult < NavigationalResults
      def initialize(range)
        @matched_range = range
      end

      def empty?
        false
      end

      def total_count
        1
      end

      def range?
        true
      end

      protected
      def prepare_results
        surah = Chapter.find_using_slug(@matched_range['surah'])
        ayah_from = @matched_range['from'].to_i
        ayah_to = @matched_range['to'].to_i

        from = [1, [ayah_from, ayah_to].min].max
        to = [surah.verses_count, [ayah_from, ayah_to].max].min

        [
          {
            result_type: 'range',
            name: "Surah #{surah.name_simple}, verse #{from} to #{to}",
            key: "#{surah.id}:#{from}-#{to}"
          }
        ]
      end
    end
  end
end
