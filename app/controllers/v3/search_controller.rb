class V3::SearchController < ApplicationController
  include LanguageDetection

  def index
    search = Search::Client.new(
        query,
        page: page,
        size: size
    )

    search.request

    render json: {
        query: search.query.query,
        total: search.total,
        page: search.page,
        size: search.size,
        from: search.from + 1,
        took: {
            total: search.delta_time,
            elasticsearch: search.response.took.to_f / 1000
        },
        results: search.response.records
    }
  end

  protected

  def language
    params[:language] || 'en'
  end

  def query
    params[:q] || params[:query]
  end

  def size(default = 20)
    (params[:size] || params[:s] || default).to_i
  end

  def page
    params[:page] || params[:p] || 1
  end
end