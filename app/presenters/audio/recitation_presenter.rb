# frozen_string_literal: true

class Audio::RecitationPresenter < BasePresenter
  RECITER_FIELDS = [
    'bio',
    'profile_picture',
    'cover_image'
  ]

  def recitations
    relation = Audio::Recitation
                 .includes(:recitation_style, :qirat_type, reciter: :translated_name)
                 .eager_load(reciter: :translated_name)
                 .order('priority ASC, language_priority DESC')

    eager_load_translated_name filter_recitations(relation)
  end

  def reciter_fields
    strong_memoize :fields do
      if (fields = params[:fields]).presence
        fields.split(',').select do |field|
          RECITER_FIELDS.include?(field)
        end
      else
        []
      end
    end
  end

  def approved_recitations
    recitations.approved
  end

  def recitation
    recitations.find_by(id: recitation_id) || raise_404("Recitation not found")
  end

  def recitation_without_eager_load
    Audio::Recitation.find_by(id: recitation_id) || raise_404("Recitation not found")
  end

  def approved_recitation
    approved_recitations.find_by(id: recitation_id) || raise_404("Recitation not found")
  end

  def related_recitations
    approved_recitations.where(id: recitation_without_eager_load.related_recitations)
  end

  def chapter_audio_file
    file = approved_audio_files.where(chapter_id: chapter.id).first

    file || raise_404("Sorry. Audio file for this surah is missing.")
  end

  def audio_files
    recitation_without_eager_load.chapter_audio_files
  end

  def approved_audio_files
    files = recitation_without_eager_load
              .chapter_audio_files
              .order('audio_chapter_audio_files.chapter_id ASC')

    if include_segments?
      files.includes(:audio_segments).order('audio_segments.verse_id ASC')
    else
      files
    end
  end

  def include_segments?
    chapter_id && include_in_response?(params[:segments].presence)
  end

  def chapter
    strong_memoize :chapter do
      if chapter_id
        Chapter.find_using_slug(chapter_id) || raise_404("Surah number or slug is invalid. Please select valid slug or surah number from 1-114.")
      else
        raise_404("Surah number or slug is invalid. Please select valid slug or surah number from 1-114.")
      end
    end
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

  def filter_recitations(recitations)
    if params[:filter_reciter]
      recitations.where(reciter_id: params[:filter_reciter].to_i)
    else
      recitations
    end
  end
end
