# frozen_string_literal: true

class V3::SuggestController < ApplicationController
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

  def language
    params[:l] || params[:language] || 'en'
  end

  def query
    params[:q] || params[:query]
  end
end
