class TafsirsController < ApplicationController
  before_action :set_tafsir, only: [:show, :update, :destroy]

  # GET /tafsirs
  def index
    @tafsirs = Tafsir.all

    render json: @tafsirs
  end

  # GET /tafsirs/1
  def show
    render json: @tafsir
  end

  # POST /tafsirs
  def create
    @tafsir = Tafsir.new(tafsir_params)

    if @tafsir.save
      render json: @tafsir, status: :created, location: @tafsir
    else
      render json: @tafsir.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /tafsirs/1
  def update
    if @tafsir.update(tafsir_params)
      render json: @tafsir
    else
      render json: @tafsir.errors, status: :unprocessable_entity
    end
  end

  # DELETE /tafsirs/1
  def destroy
    @tafsir.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tafsir
      @tafsir = Tafsir.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def tafsir_params
      params.require(:tafsir).permit(:resource_id, :language_id, :text, :resource_content_id)
    end
end
