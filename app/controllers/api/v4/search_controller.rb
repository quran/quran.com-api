# frozen_string_literal: true
module Api::V4
  class SearchController < ApiController
    include LanguageBoost
    QUERY_SANITIZER = Rails::Html::WhiteListSanitizer.new

    def search
      if do_search
        render
      else
        #TODO: render error
      end
    end

    protected

    def language
      (params[:language] || params[:locale]).presence || 'en'
    end

    def query
      query = (params[:q] || params[:query]).to_s.strip.first(150)
      params[:q] = QUERY_SANITIZER.sanitize(query)
    end

    def size(default = 20)
      (params[:size] || params[:s] || default).to_i
    end

    def page
      # NODE: ES's pagination starts from 0,
      # pagy gem we're using to render pagination start pages from 1
      (params[:page] || params[:p]).to_i.abs
    end

    def do_search
      client = Search::QuranSearchClient.new(
          query,
          page: page,
          size: size,
          lanugage: language,
          phrase_matching: force_phrase_matching?
      )

      @presenter = SearchPresenter.new(params, query)

      begin
        results = client.search

        @presenter.add_search_results(results)
      rescue Faraday::ConnectionFailed => e
        false
      rescue Elasticsearch::Transport::Transport::ServerError => e
        # Index not ready yet? or other ES server errors
        false
      end
    end

    def force_phrase_matching?
      params[:phrase].presence || query.match?(/\d+(:)?(\d+)?/)
    end
  end
end
