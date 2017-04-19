class V3::ChaptersController < ApplicationController
  # GET /chapters
  def index
    chapters = Chapter.all

    render json: chapters
  end

  # GET /chapters/1
  def show
    chapter = Chapter.find(params[:id])

    render json: chapter
  end
end