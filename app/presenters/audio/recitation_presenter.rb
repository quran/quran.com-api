# frozen_string_literal: true

class Audio::RecitationPresenter < BasePresenter
  def recitations
    Audio::Recitation.all
  end

  def recitation
    Audio::Recitation.find(params[:id])
  end

  def related
    recitation.related_recitations
  end

  def chapter_audio_file
    audio_files.where(chapter_id: chapter_id).first
  end

  def audio_files
    recitation.chapter_audio_files
  end

  def chapter_id
    params[:chapter_number]
  end
end
