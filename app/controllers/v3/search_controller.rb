# frozen_string_literal: true

class V3::SearchController < ApplicationController
  include LanguageDetection

  def index
    client = Search::Client.new(
      query,
      page: page, size: size, lanugage: language
    )

    response = client.search

    render json: {
      query: query,
      total_count: response.total_count,
      took: response.took,
      current_page: response.current_page,
      total_pages: response.total_pages,
      per_page: response.per_page,
      results: response.results
    }

    # render json: {
    #     query: search.query.query,
    #     total: search.total,
    #     page: search.page,
    #     size: search.size,
    #     from: search.from + 1,
    #     took: {
    #         total: search.delta_time,
    #         elasticsearch: search.response.took.to_f / 1000
    #     },
    #     results: search.response.records
    # }
  end

  protected

    def language
      params[:language] || "en"
    end

    def query
      params[:q] || params[:query]
    end

    def size(default = 20)
      (params[:size] || params[:s] || default).to_i
    end

    def page
      p = (params[:page] || params[:p]).to_i

      p.zero? ? 1 : p
    end
end
