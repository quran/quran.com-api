# frozen_string_literal: true

module Api::V3
  class ChapterInfosController < ApplicationController
    # GET /chapters/1/info
    def show
      chapter_info = ChapterInfo.where(chapter_id: params[:id]).filter_by_language_or_default(params[:language])

      render json: chapter_info
    end
  end
end
