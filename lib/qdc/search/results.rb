# frozen_string_literal: true
module Qdc
  module Search
    class Results
      QURAN_AYAHS_INDEX = 'quran_verses'

      def initialize(search, page, page_size)
        @search = search
        @result_size = 0
        @current_page = page
        @page_size = page_size
      end

      def results
        if empty?
          {}
        else
          prepare_results
        end
      end

      def pagination
        Pagy.new(count: total_count, page: @current_page + 1, items: @page_size)
      end

      def empty?
        @search.empty? || @page_size.zero?
      end

      def timed_out?
        @search.timed_out
      end

      def took
        @search.took
      end

      protected

      def total_count
        @search.response['hits']['total']['value']
      end

      def prepare_results
        @search.response['hits']['hits'].map do |hit|
          document = hit['_source'].to_h
          document['id'] = hit['_id']

          if hit['highlight']
            document['text'] = hit['highlight']['text'][0]
          end

          if QURAN_AYAHS_INDEX == hit['_index']
            highlighted_words = hit.dig('inner_hits', 'words', 'hits', 'hits')
            document['highlighted_words'] = highlighted_words.map do |w|
              w['_source']["id"]
            end
          end

          document
        end
      end

      def fetch_navigational_highlighted_text(hit)
        highlight = hit['_source']

        if hit['highlight'].present?
          highlight['highlight'] = hit['highlight'].values[0][0]
        end

        highlight
      end
    end
  end
end
