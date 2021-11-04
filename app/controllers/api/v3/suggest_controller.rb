# frozen_string_literal: true

module Api::V3
  class SuggestController < ApiController
    def index
      if query.nil?
        render status: :bad_request, json: [].to_json
      else
        render json: get_suggestions
      end
    end

    def get_suggestions
      Search::Suggest.new(query, lang: language).get_suggestions
    end

    protected
    def language
      params[:l] || params[:language] || 'en'
    end

    def query
      params[:q] || params[:query]
    end
  end
end
