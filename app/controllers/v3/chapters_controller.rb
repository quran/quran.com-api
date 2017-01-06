class V3::ChaptersController < ApplicationController
  # GET /chapters
  def index
    chapters = Chapter.includes(:translated_names).all

    render json: chapters, params: params, a: :b
  end

  # GET /chapters/1
  def show
    chapter = Chapter.find(params[:id])

    render json: chapter
  end
end