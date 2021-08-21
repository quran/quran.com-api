# frozen_string_literal: true
module Qdc
  module Search
    class Results
      attr_reader :result_type

      def initialize(search, page, search_type = nil)
        @search = search
        @record_highlights = {}
        @result_size = 0
        @current_page = page
        @result_type = search_type
      end

      def results
        if empty?
          {}
        else
          prepare_highlights

          @record_highlights
        end
      end

      def get_me
        @record_highlights
      end

      def pagination
        Pagy.new(count: total_count, page: @current_page + 1, per_page: VERSES_PER_PAGE)
      end

      def empty?
        @search.empty?
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

      def prepare_highlights
        @search.response['hits']['hits'].each do |hit|
          if :navigation == @result_type
            @record_highlights[hit['_source']['url']] = fetch_navigational_highlighted_text(hit)
          else
            hit_source = hit['_source'].to_h
            verse_id = hit_source['verse_id']

            @record_highlights[verse_id] ||= []
            @record_highlights[verse_id].push(
              hit_source.merge(
                text: fetch_verse_highligted_text(hit['highlight'])
              )
            )
          end
          @result_size += 1
        end
      end

      def fetch_navigational_highlighted_text(hit)
        highlight = hit['_source']

        if hit['highlight'].present?
          highlight['highlight'] = hit['highlight'].values[0][0]
        end

        highlight
      end

      def fetch_verse_highligted_text(highlight)
        if highlight.presence
          highlight.values[0][0]
        end
      end
    end
  end
end
