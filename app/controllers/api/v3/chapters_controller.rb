# frozen_string_literal: true

module Api::V3
  class ChaptersController < ApplicationController
    # GET /chapters
    def index
      render json: chapters
    end

    # GET /chapters/1
    def show
      render json: chapter
    end

    protected
    def chapters
      finder = ChapterFinder.new
      finder.all_with_eager_load(locale: fetch_locale)
    end

    def chapter
      finder = ChapterFinder.new
      finder.find_and_eager_load(params[:id], locale: fetch_locale)
    end
  end
end
