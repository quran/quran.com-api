# frozen_string_literal: true

module Api::V4
  class SearchController < ApiController
    QUERY_SANITIZER = Rails::Html::WhiteListSanitizer.new

    def search
      if do_search
        render
      else
        render_request_error("Something went wrong", 500)
      end
    end

    protected

    def language
      (params[:language] || params[:locale]).presence
    end

    def translations
      strong_memoize :valid_translations do
        # user can get translation using ids or Slug
        translation = params[:translations].to_s.split(',')

        return [] if translation.blank?

        approved_translations = ResourceContent
                                  .approved
                                  .translations
                                  .one_verse

        params[:translations] = approved_translations
                                  .where(id: translation)
                                  .or(approved_translations.where(slug: translation))
                                  .pluck(:id)
        params[:translations]
      end
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
      content_client = Search::QuranSearchClient.new(
        query,
        page: page,
        per_page: per_page,
        language: language,
        translations: translations
      )
      @presenter.add_search_results(content_client.search)
    end
  end
end
