class TafsirsController < ApplicationController
  def index
    tafsir = Tafsir.includes(:foot_notes).where(verse_id: params[:verse_id])

    if params[:id]
      #Filter by resource content, in case client want tafsir of specific author
      tafsir = tafsir.where(resource_content_id: params[:id])
    end

    render json: tafsir
  end
end
