# frozen_string_literal: true

class Audio::RadioPresenter < Audio::RecitationPresenter
  STATION_FIELDS = [
    'profile_picture',
    'cover_image',
    'description'
  ]

  def radio_stations
    stations = Radio::Station
                 .eager_load(:translated_name)
                 .order('priority ASC')

    eager_load_translated_name stations
  end

  def radio_station

  end

  def station_fields
    strong_memoize :fields do
      if (fields = params[:fields]).presence
        fields.split(',').select do |field|
          STATION_FIELDS.include?(field)
        end
      else
        []
      end
    end
  end

  def station_audio_files
    files = radio_station.chapter_audio_files.order('audio_chapter_audio_files.chapter_id ASC')

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
end
