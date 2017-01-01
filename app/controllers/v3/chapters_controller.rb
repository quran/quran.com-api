class V3::ChaptersController < ApplicationController
  before_action :detect_language

  # GET /chapters
  def index
    chapters = Chapter.all

    render json: ChapterSerializer.new(chapters.first).to_json
  end

  # GET /chapters/1
  def show
    render json: @chapter
  end

  private
  # Only allow a trusted parameter "white list" through.
  def chapter_params
    params.require(:chapter).permit(:bismillah_pre, :revelation_order, :revelation_place, :name_complex, :name_simple, :verses_count)
  end
end
