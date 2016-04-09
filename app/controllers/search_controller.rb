class SearchController < ApplicationController
  def query
    return render json: {message: 'Query param is invalid'}, status: 400 unless search_query?

    query = params[:q] || params[:query]
    page = params[:page] || params[:p] || 1
    size = params[:size] || params[:s] || 20

    indices_boost = Search::LanguageDetection.new(headers, session, query).indices_boost

    search = Search::Client.new(
      query,
      page: page,
      size: size,
      indices_boost: indices_boost,
      content: params[:content],
      audio: params[:audio]
    )

    search.request

    render json: {
      query: params[:q],
      total: search.total,
      page: search.page,
      size: search.size,
      from: search.from + 1,
      took: {
        total: search.delta_time,
        elasticsearch: (search.response.took.to_f / 1000)
      },
      results: search.response.records
    }
  end

  def suggest
    return render json: {message: 'Query param is invalid'}, status: 400 unless search_query?
    query = params[:q] || params[:query]

    search = Search::Suggest::Client.new(query,
      lang: params[:l] || params[:lang] || 'en', # TODO we need to explicitly pass in lang, this default shouldn't be around forever
      size: ( params[:s] || params[:size] || '5' ).to_i
    )

    search.request

    render json: search.result
  end

private

  def search_query?
    valid_string?
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
