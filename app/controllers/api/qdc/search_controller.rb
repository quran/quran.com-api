# frozen_string_literal: true

module Api::Qdc
  class SearchController < ApiController
    QUERY_SANITIZER = Rails::Html::WhiteListSanitizer.new

    def search
      if do_search
        render
      else
        render partial: 'error', status: 500
      end
    end

    protected

    def language
      (params[:language] || params[:locale]).presence
    end

    def translations
      params['translations'].to_s.split(',')
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
      if(p=(params[:page] || params[:p]))
        [0, p.to_i - 1].max
      else
        0
      end
    end

    def do_search
      @presenter = SearchPresenter.new(params, query)

      do_navigation_search
      do_text_search
    end

    def do_navigation_search
      navigational_client = Qdc::Search::NavigationClient.new(query)

      begin
        results = navigational_client.search
        @presenter.add_navigational_results(results)
      rescue Faraday::ConnectionFailed => e
        false
      rescue Elasticsearch::Transport::Transport::ServerError => e
        # Index not ready yet? or other ES server errors
        false
      end
    end

    def do_text_search
      content_client = Qdc::Search::QuranSearchClient.new(
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
