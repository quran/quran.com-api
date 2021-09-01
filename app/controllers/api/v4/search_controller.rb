# frozen_string_literal: true

module Api::V4
  class SearchController < ApiController
    QUERY_SANITIZER = Rails::Html::WhiteListSanitizer.new

    def search
      if do_search
        render
      else
        # TODO: render error
      end
    end

    protected

    def language
      (params[:language] || params[:locale]).presence || 'en'
    end

    def query
      query = (params[:q] || params[:query]).to_s.strip.first(250)
      params[:q] = QUERY_SANITIZER.sanitize(query)
    end

    def size(default = 10)
      (params[:size] || params[:s] || params[:per_page] || default).to_i.abs
    end

    def page
      # NODE: ES's pagination starts from 0,
      # pagy gem we're using to render pagination start pages from 1
      if (p = (params[:page] || params[:p]))
        [0, p.to_i - 1].max
      else
        0
      end
    end

    def do_search
      @presenter = SearchPresenter.new(params, query)

      content_client = Search::QuranSearchClient.new(
        query,
        page: page,
        per_page: size,
        language: language,
        translations: translations
      )

      begin
        @presenter.add_search_results(content_client.search)
      rescue Faraday::ConnectionFailed => e
        @error = e
        false
      rescue Elasticsearch::Transport::Transport::ServerError => e
        # Index not ready yet? or other ES server errors
        @error = e
        false
      end
    end
  end
end
