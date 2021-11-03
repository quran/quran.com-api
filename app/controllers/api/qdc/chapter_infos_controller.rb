# frozen_string_literal: true

module Api::Qdc
  class ChapterInfosController < ApiController
    def show
      @chapter_info = chapter_info
      render
    end

    protected
    def chapter_info
      finder = ChapterFinder.new
      chapter = finder.find(params[:id])

      ChapterInfo
          .where(chapter_id: chapter.id)
          .filter_by_language_or_default(fetch_locale)
    end
  end
end
