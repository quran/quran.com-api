# frozen_string_literal: true

class Audio::RecitationPresenter < BasePresenter
  def recitations
    Audio::Recitation.all
  end

  def approved_recitations
    Audio::Recitation.approved
  end

  def recitation
    Audio::Recitation.find(recitation_id)
  end

  def approved_recitation
    approved_recitations.find(recitation_id)
  end

  def related
    recitation.related_recitations
  end

  def chapter_audio_file
    approved_audio_files.where(chapter_id: chapter_id).first
  end

  def audio_files
    recitation.chapter_audio_files
  end

  def approved_audio_files
    approved_recitation.chapter_audio_files
  end

  def chapter_id
    params[:chapter_number]
  end

  def recitation_id
    params[:id]
  end
end
