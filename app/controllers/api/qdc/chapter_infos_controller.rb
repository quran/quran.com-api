# frozen_string_literal: true

module Api::Qdc
  class ChapterInfosController < ApiController
    def show
      @chapter_info = chapter_info
      render
    end

    protected
    def chapter_info
      chapter = ChapterFinder.new().find_and_eager_load(params[:id], locale: 'en')

      ChapterInfo
          .where(chapter_id: chapter.id)
          .filter_by_language_or_default(fetch_locale)
    end
  end
end
