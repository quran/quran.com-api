# frozen_string_literal: true

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
        preppare_heighlights
        @record_highlights
      end
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

    def preppare_heighlights
      @search.response['hits']['hits'].each do |hit|
        if :navigation == @result_type
          @record_highlights[hit['_source']['url']] = fetch_navigational_highlighted_text(hit)
        else
          @record_highlights[hit['_source']['verse_id']] = {
              text: fetch_verse_highligted_text(hit['highlight']),
              translations: fetch_translations(hit)
          }
        end
        @result_size += 1
      end
    end

    def fetch_navigational_highlighted_text(hit)
      if hit['highlight'].present?
        hit['highlight'].values[0][0]
      else
        hit['_source']['name']
      end
    end

    def fetch_verse_highligted_text(highlight)
      if highlight.presence
        highlight.values[0][0]
      end
    end

    def fetch_translations(hit)
      return [] if hit['inner_hits'].blank?

      translations = []

      hit['inner_hits'].each do |lang, inner_hit|
        total = inner_hit['hits']['total']['value']

        if total > 0
          language = inner_hit['hits']['hits'][0]['_source']['language']

          inner_hit['hits']['hits'].first(5).map do |trans_hit|
            _source = trans_hit['_source']

            translations << {
                resource_id: _source['resource_id'],
                resource_name: _source['resource_name'],
                id: trans_hit['_id'],
                text: trans_hit['highlight'].values[0][0],
                language: language
            }
          end
        end
      end

      translations
    end
  end
end
