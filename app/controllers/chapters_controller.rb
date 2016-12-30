class ChaptersController < ApplicationController
  before_action :set_chapter, only: [:show, :update, :destroy]

  # GET /chapters
  def index
    @chapters = Chapter.all

    render json: @chapters
  end

  # GET /chapters/1
  def show
    render json: @chapter
  end

  # POST /chapters
  def create
    @chapter = Chapter.new(chapter_params)

    if @chapter.save
      render json: @chapter, status: :created, location: @chapter
    else
      render json: @chapter.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /chapters/1
  def update
    if @chapter.update(chapter_params)
      render json: @chapter
    else
      render json: @chapter.errors, status: :unprocessable_entity
    end
  end

  # DELETE /chapters/1
  def destroy
    @chapter.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chapter
      @chapter = Chapter.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def chapter_params
      params.require(:chapter).permit(:bismillah_pre, :revelation_order, :revelation_place, :name_complex, :name_simple, :verses_count)
    end
end
