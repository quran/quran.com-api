# frozen_string_literal: true

class V3::ChaptersController < ApplicationController
  # GET /chapters
  def index
    finder = ChapterFinder.new

    render json: finder.all_with_translated_names(fetch_locale)
  end

  # GET /chapters/1
  def show
    finder = ChapterFinder.new

    render json: finder.find_with_translated_name(params[:id], fetch_locale)
  end
end
