# frozen_string_literal: true

class Audio::SegmentPresenter < BasePresenter
  def segments
    file_segments = filter_audio_segments

    if verse_id
      file_segments = file_segments.where(verse_id: verse_id)
    end

    file_segments
  end

  def lookup_ayah
    if start_timestamp || end_timestamp
      filter_audio_segments.first
    else
      nil
    end
  end

  def ayah_timing_percentile
    audio_file_segments.pluck(:percentile)
  end

  protected

  def filter_audio_segments
    file_segments = audio_file_segments

    if start_timestamp
      file_segments = file_segments.where('start_timestamp >= ?', start_timestamp)
    end

    if end_timestamp
      file_segments = file_segments.where('end_timestamp <= ?', end_timestamp)
    end

    file_segments
  end

  def audio_file_segments
    Audio::Segment
      .where(audio_file_id: audio_file_id)
      .order('verse_number ASC')
  end

  def audio_file_id
    params[:audio_file_id]
  end

  def chapter_id
    params[:chapter_number] || params[:chapter_id]
  end

  def verse_id
    strong_memoize :verse_id do
      return params[:verse_id].to_i if params[:verse_id]

      if (key = params[:verse_key])
        QuranUtils::Quran.get_ayah_id_from_key(key)
      end
    end
  end

  def start_timestamp
    params[:start_timestamp].to_i if params[:start_timestamp].present?
  end

  def end_timestamp
    params[:end_timestamp].to_i if params[:end_timestamp].present?
  end
end
