# vim: ts=4 sw=4 expandtab
# DONE 1. set analyzers for every language
# TODO 1.a. actually configure the analyzer so that certain words are protected (like allah, don't want to stem that). hopefully an alternate solution is available, so this isn't priority until the steps below are done.
# TODO 2. determine the language of the query (here)
# TODO 3. apply weights to different types of indices e.g. text > tafsir
# TODO 4. break down fields into analyzed and unanalyzed and weigh them
#
# NEW
# TODO 1. determine language
#      2. refactor query accordingly
#      3. refactor code
#      4. refine search, optimize for performance


# Determining query language
# - Determine if Arabic (regex); if not, determine boost using the following...
#   a. Use Accept-Language HTTP header
#   b. Use country-code to language mapping (determine country code from geolocation)
#   c. Use language-code from user application settings (should get at least double priority to anything else)
#   d. Fallback to boosting English if nothing was determined from above and the query is pure ascii

class SearchController < ApplicationController
  def query
    query = params[:q] || params[:query]

    indices_boost = Search::LanguageDetection.new(headers, session, query).indices_boost

    search = Search::Query.new(query, {
      page: [(params[:page] || params[:p] || 1 ).to_i, 1].max,
      size: [[(params[:size] || params[:s] || 20).to_i, 20].max, 40].min, # sets the max to 40 and min to 20
      indices_boost: indices_boost,
      content: params[:content], # The user can specific what audio or additional content to retrieve
      audio: params[:audio]
    })

    search.request

    render json: {
      query: params[:q],
      total: search.response.size,
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
end
