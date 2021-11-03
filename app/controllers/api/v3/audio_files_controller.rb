# frozen_string_literal: true

module Api::V3
  class AudioFilesController < ApiController
    def index
      chapter = Chapter.find(params[:chapter_id])
      verse = chapter.verses.find(params[:verse_id])
      data = verse.audio_files
      data = data.find_by(recitation_id: recitation) if recitation.present?

      render json: data
    end

    private
    def recitation
      params[:recitation]
    end
  end
end
