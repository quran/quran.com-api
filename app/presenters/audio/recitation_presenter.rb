# frozen_string_literal: true

class Audio::RecitationPresenter < BasePresenter
  def recitations
    Audio::Recitation.order('name ASC')
  end

  def render_info?
    strong_memoize :render_recitation_idno do
      @lookahead.selects?('info')
    end
  end

  def approved_recitations
    audio_recitations = Audio::Recitation
                          .approved
                          .includes(:recitation_style, :qirat_type)
                          .eager_load(:translated_name)
                          .order('priority ASC')

    eager_load_translated_name audio_recitations
  end

  def recitation
    Audio::Recitation.find_by(id: recitation_id) || raise_404("Recitation not found")
  end

  def approved_recitation
    approved_recitations.find_by(id: recitation_id) || raise_404("Recitation not found")
  end

  def related_recitations
    audio_recitations = recitation
                          .related_recitations
                          .includes(:recitation_style, :qirat_type)
                          .eager_load(:translated_name)
                          .order('priority ASC')

    eager_load_translated_name audio_recitations
  end

  def chapter_audio_file
    approved_audio_files.where(chapter_id: chapter_id).first
  end

  def audio_files
    recitation.chapter_audio_files
  end

  def approved_audio_files
    files = approved_recitation.chapter_audio_files.order('audio_chapter_audio_files.chapter_id ASC')

    files = if chapter_id
              files.where(chapter_id: chapter_id)
            else
              files
            end

    if include_segments?
      files.includes(:audio_segments).order('audio_segments.verse_id ASC')
    else
      files
    end
  end

  def include_segments?
    include_in_response? params[:segments].presence
  end

  protected

  def chapter_id
    strong_memoize :chapter_id do
      id = params[:chapter_number] || params[:chapter_id] || params[:chapter]

      if id.present?
        id
      else
        if verse_id
          QuranUtils::Quran.get_chapter_id_from_verse_id(verse_id)
        end
      end
    end
  end

  def recitation_id
    params[:reciter_id]
  end

  def verse_id
    strong_memoize :verse_id do
      return params[:verse_id].to_i if params[:verse_id]

      if (key = params[:verse_key])
        QuranUtils::Quran.get_ayah_id_from_key(key)
      end
    end
  end
end
