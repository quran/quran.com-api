# frozen_string_literal: true

class V3::AudioFilesController < ApplicationController
  def index
    chapter = Chapter.find(params[:chapter_id])
    verse = chapter.verses.find(params[:verse_id])
    data = verse.audio_files
    data = data.find_by_recitation_id(recitation) if recitation.present?

    render json: data
  end

  private

    def recitation
      params[:recitation]
    end
end
