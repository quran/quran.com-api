class V3::TafsirsController < ApplicationController
  def index
    chapter = Chapter.find(params[:chapter_id])
    verse   = chapter.verses.find(params[:verse_id])
    tafsirs = verse.tafsirs.where(resource_content_id: params[:tafsirs])

    render json: tafsirs
  end
end
