# frozen_string_literal: true

class V4::RecitationFinder < V4::VerseFinder
  attr_reader :recitation

  def load_audio(filter, recitation)
    @recitation = recitation
    load_recitation_range(filter)
  end

  protected
  def load_recitation_range(filter)
    results = send("fetch_#{filter}", recitation)

    results = results.limit(per_page)
                  .offset((current_page - 1) * per_page)

    if current_page < total_pages
      @next_page = current_page + 1
    end

    results
  end

  def fetch_by_chapter(recitation)
    if chapter = Chapter.find_by(id: params[:chapter_number].to_i.abs)
      @total_records = chapter.verses_count
      results = filter_audio_files(recitation)
                    .where(chapter_id: params[:chapter_number].to_i.abs)
    else
      results = AudioFile.where('1=0')
    end

    results
  end

  def fetch_by_page(recitation)
    results = filter_audio_files(recitation)
                  .where(page_number: params[:page_number].to_i.abs)

    @total_records = results.size

    results
  end

  def fetch_by_rub(recitation)
    results = filter_audio_files(recitation)
                  .where(rub_number: params[:rub_number].to_i.abs)

    @total_records = results.size

    results
  end

  def fetch_by_hizb(recitation)
    results = filter_audio_files(recitation)
                  .where(hizb_number: params[:hizb_number].to_i.abs)

    @total_records = results.size
    results
  end

  def fetch_by_juz(recitation)
    if juz = Juz.find_by(juz_number: params[:juz_number].to_i.abs)
      @total_records = juz.verses_count

      results = filter_audio_files(recitation)
                    .where(juz_number: juz.juz_number)

      results
    else
      AudioFile.where('1=0')
    end
  end

  def fetch_by_ayah(recitation)
    @total_records = 1
    filter_audio_files(recitation).where(verse_key: params[:ayah_key])
  end

  def filter_audio_files(recitation)
    AudioFile.where(recitation_id: recitation).order('verse_id ASC')
  end
end
