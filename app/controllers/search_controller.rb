class SearchController < ApplicationController
  def query
    return render json: {message: 'Query param is invalid'}, status: 400 unless search_query?

    query = params[:q] || params[:query]

    indices_boost = Search::LanguageDetection.new(headers, session, query).indices_boost

    search = Search::Query::Client.new(query,
      page: params[:page] || params[:p] || 1,
      size: params[:size] || params[:s] || 20,
      indices_boost: indices_boost,
      content: params[:content], # The user can specific what audio or additional content to retrieve
      audio: params[:audio]
    )

    search.request

    if search.errored?
      return render json: {error: 'Something wrong happened'}, status: 400
    end

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
