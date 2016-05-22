class V2::SearchController < ApplicationController
  include LanguageDetection

  before_filter :search_query?

  api :GET, '/v2/search', 'Quran search'
  api_version '2.0'
  param :q, String, desc: 'Query string to search', requred: true
  param :page, :number, desc: 'Page number'
  param :size, :number, desc: 'Size of results per page'
  def index
    search = Search::Client.new(
      query,
      page: page,
      size: size,
      indices_boost: indices_boost,
      content: content,
      audio: audio
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

  def suggest
    search = Search::Suggest::Client.new(
      query,
      lang: language,
      size: size(5)
    )

    search.request

    render json: search.result
  end

private

  def language
    params[:l] || params[:lang] || 'en'
  end

  def content
    params[:content]
  end

  def audio
    params[:audio]
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

  def search_query?
    return render json: {message: 'Query param is invalid'}, status: 400 unless valid_string?
  end

  def has_query?
    params.has_key?(:q) || params.has_key?(:query)
  end

  def valid_string?
    if has_query?
      if params.has_key?(:q)
        !params[:q].empty?
      elsif params.has_key?(:query)
        !params[:query].empty?
      end
    end
  end
end
