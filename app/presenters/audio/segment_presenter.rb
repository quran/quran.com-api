# frozen_string_literal: true

class Audio::SegmentPresenter < Audio::RecitationPresenter
  # Fine ayah segment give chapter id, reciter id and timestamp
  def lookup_ayah
    if chapter_id && recitation_id && timestamp
      segments = audio_file_segments
      find_closest_segment(segments, timestamp)
    else
      nil
    end
  end

  # find timestamp range give chapter id, reciter id and optionally word range
  def find_timestamp
    if chapter_id && recitation_id
      segments = audio_file_segments
      timestamps = filter_timestamps(segments)

      if timestamps.present?
        return {
          timestamp_from: timestamps[0],
          timestamp_to: timestamps[1]
        }
      end
    end

    # no timestamp found
    {}
  end

  protected

  # Find timestamp range for surah, ayah or words
  def filter_timestamps(segments)
    time_from, time_to = nil

    if verse_id
      if segment = segments.where(verse_id: verse_id).first
        if filter_timestamp_for_words?
          # Filter for words
          time_from, time_to = filter_timestamp_for_words(segment)
        else
          # Return timestamp of whole ayah
          time_from = segment.timestamp_from
          time_to = segment.timestamp_to
        end
      end
    else
      # Return timestamp of whole surah
      first = segments.first
      last = segments.last

      time_from = first.timestamp_from
      time_to = last.timestamp_to
    end

    [time_from, time_to].compact_blank
  end

  def filter_timestamp_for_words(audio_segment)
    segments = audio_segment.segments

    if params[:word]
      # Single word has priority
      segment = segments[params[:word].to_i]

      return [segment[1], segment[2]]
    end

    segment_from = segments[params[:word_from].to_i]
    segment_to = segments[params[:word_to].to_i]

    if segment_from && segment_to
      [segment_from[1], segment_to[2]]
    end
  end

  # Find segment that is closest to give timestamp
  # give this segments array, [[5,200], [210, 250], [270, 290]], the closest segment to 260 is [270, 290]
  def find_closest_segment(segments, time)
    closest_segment = segments[0]
    closest_diff = (closest_segment.timestamp_median - time).abs

    segments.each do |segment|
      diff = (segment.timestamp_median - time).abs

      if closest_diff >= diff && time > closest_segment.timestamp_to
        closest_diff = diff
        closest_segment = segment
      end
    end

    closest_segment
  end

  def audio_file_segments
    filters = {
      audio_recitation_id: recitation_id,
      chapter_id: chapter_id
    }.compact_blank

    Audio::Segment
      .where(filters).order('verse_number ASC')
  end

  def timestamp
    params[:timestamp].to_i if params[:timestamp].present?
  end

  def filter_timestamp_for_words?
    params[:word] || (params[:word_from] && params[:word_to])
  end
end
