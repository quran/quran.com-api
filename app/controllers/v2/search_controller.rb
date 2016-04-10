class V2::SearchController < ApplicationController
  before_filter :search_query?

  def index
    indices_boost = Search::LanguageDetection.new(headers, session, query).indices_boost

    @search = Search::Client.new(
      query,
      page: page,
      size: size,
      indices_boost: indices_boost,
      content: content,
      audio: audio
    )

    @search.request
    @search
  end

  def suggest
  end

private

  def content
    params[:content]
  end

  def audio
    params[:audio]
  end

  def query
    params[:q] || params[:query]
  end

  def size
    params[:size] || params[:s] || 20
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
