# frozen_string_literal: true

module Api::V3
  class AudioFilesController < ApiController
    def index
      verse = chapter.verses.find(params[:verse_id])
      @audio_files = verse.audio_files
      @recitation = recitation
      @audio_files = @audio_files.find_by(recitation_id: @recitation) if @recitation.present?

      render
    end

    private
    def recitation
      params[:recitation]
    end

    def chapter
      finder = ChapterFinder.new
      finder.find(params[:chapter_id])
    end
  end
end
