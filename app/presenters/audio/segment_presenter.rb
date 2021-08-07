# frozen_string_literal: true

class Audio::SegmentPresenter < Audio::RecitationPresenter
  def lookup_ayah
    filter_audio_segments.first
  end

  def ayah_timing_percentile
    []
    #audio_file_segments.pluck(:percentile)
  end

  protected

  def filter_audio_segments
    file_segments = audio_file_segments

    if timestamp_from
      file_segments = file_segments.where('start_timestamp <= ? AND end_timestamp >= ?', timestamp_from, timestamp_from)
    end

    if verse_id
      file_segments = file_segments.where(verse_id: verse_id)
    end

    file_segments
  end

  def audio_file_segments
    filters = {
      surah_recitation_id: recitation_id,
      chapter_id: chapter_id
    }.compact_blank

    Audio::Segment
      .where(filters).order('verse_number ASC')
  end

  def timestamp_from
    params[:timestamp].to_i if params[:timestamp].present?
  end
end
