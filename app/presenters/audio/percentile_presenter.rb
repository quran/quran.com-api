class Audio::PercentilePresenter < Audio::SegmentPresenter
  def ayah_cumulative_percentile
    filters = {
      audio_recitation_id: recitation_id,
      chapter_id: chapter_id
    }

    audio_file = Audio::ChapterAudioFile.where(filters).first

    if audio_file
      audio_file.timing_percentiles
    else
      []
    end
  end

  def ayah_duration_percentile
    audio_file_segments.pluck :percentile, :verse_key
  end
end