# frozen_string_literal: true
module Api::V4
  class ChaptersController < ApiController
    def index
      @chapters = chapters
      render json: @chapters
    end

    def show
      @chapter = chapter
      render json: @chapter
    end

    protected

    def chapters
      finder = ChapterFinder.new
      finder.all_with_translated_names(fetch_locale)
    end

    def chapter
      finder = ChapterFinder.new
      finder.find_with_translated_name(params[:id], fetch_locale)
    end
  end
end
