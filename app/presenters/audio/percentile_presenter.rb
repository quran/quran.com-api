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
    audio_file_segments.map do |segment|
      {
        verse_key: segment.verse_key,
        from: segment.timestamp_from,
        to: segment.timestamp_to,
        percentile: segment.percentile
      }
    end
  end
end