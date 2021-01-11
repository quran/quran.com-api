# frozen_string_literal: true
module Api::V4
  class ChapterInfosController < ApiController
    def show
      @chapter_info = chapter_info
      render
    end

    protected

    def chapter_info
      ChapterInfo
          .where(chapter_id: params[:id])
          .filter_by_language_or_default(fetch_locale)
    end
  end
end
