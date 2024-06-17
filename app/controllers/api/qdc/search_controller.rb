# frozen_string_literal: true

module Api::Qdc
  class SearchController < ApiController
    QUERY_SANITIZER = Rails::Html::WhiteListSanitizer.new

    def search
      if do_search
        render
      else
        render_request_error("Something went wrong", 500)
      end
    end

    def navigate
      params[:page] = params[:p] = 0
      @presenter = SearchPresenter.new(params, query)

      do_navigation_search

      render
    end

    protected

    def language
      (params[:language] || params[:locale]).presence
    end

    def filter_languages
      params['filter_languages'].to_s.split(',')
    end

    def filter_translations
      # user can get translation using ids or Slug
      translation = params[:filter_translations].to_s.split(',')

      return [] if translation.blank?

      approved_translations = ResourceContent
                                .approved
                                .translations
                                .one_verse

      params[:filter_translations] = approved_translations
                                .where(id: translation)
                                .or(approved_translations.where(slug: translation))
                                .pluck(:id)
      params[:filter_translations]
    end

    def query
      query = (params[:q] || params[:query]).to_s.strip.first(250)
      params[:q] = QUERY_SANITIZER.sanitize(query)
    end

    def per_page(default = 10)
      val = (params[:size] || params[:s] || params[:per_page] || default).to_i.abs

      [val, 1].max
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

      do_navigation_search if page.zero? || (params[:page] || params[:p]).nil?
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
        per_page: per_page,
        filter_languages: filter_languages,
        filter_translations: filter_translations
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
