# frozen_string_literal: true

module Api::Qdc
  class SearchController < ApiController
    include LanguageBoost
    QUERY_SANITIZER = Rails::Html::WhiteListSanitizer.new

    def search
      if do_search
        render
      else
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

    def size(default = 20)
      (params[:size] || params[:s] || default).to_i
    end

    def page
      # NODE: ES's pagination starts from 0,
      # pagy gem we're using to render pagination start pages from 1
      (params[:page] || params[:p]).to_i.abs
    end

    def do_search
      navigational_client = Qdc::Search::NavigationClient.new(query)
      @presenter = SearchPresenter.new(params, query)

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
  end
end
