# frozen_string_literal: true

class Audio::RecitationPresenter < BasePresenter
  def recitations
    Audio::Recitation.order('name ASC')
  end

  def approved_recitations
    audio_recitations = Audio::Recitation
                          .approved
                          .includes(:recitation_style)
                          .eager_load(:translated_name)
                          .order('priority ASC')

    eager_load_translated_name audio_recitations
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
    files = approved_recitation.chapter_audio_files

    if chapter_id
      files.where(chapter_id: chapter_id)
    else
      files
    end
  end

  def chapter_id
    params[:chapter_number] || params[:chapter_id]
  end

  def recitation_id
    params[:recitation_id]
  end
end
