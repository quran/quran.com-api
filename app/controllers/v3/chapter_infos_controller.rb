class V3::ChapterInfosController < ApplicationController
  # GET /chapters/1/info
  def show
    chapter_info = ChapterInfo.where(chapter_id: params[:id]).filter_by_language_or_default(current_language)

    render json: chapter_info
  end
end