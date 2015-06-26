class Audio::File < ActiveRecord::Base
    extend Audio

    self.table_name = 'file'
    self.primary_key = 'file_id'

    belongs_to :ayah,       class_name: 'Quran::Ayah'
    belongs_to :recitation, class_name: 'Audio::Recitation'

    def self.fetch_audio_files(audio_id, keys)
        self
        .joins("join quran.ayah a using ( ayah_key )")
        .joins("left join ( select t.recitation_id
                     , f.ayah_key
                     , concat( 'http://verses.quran.com/', concat_ws( '/', r.path, s.path, f.format, concat( replace( format('%3s', a.surah_id ), ' ', '0' ), replace( format('%3s', a.ayah_num ), ' ', '0' ), '.', f.format ) ) ) url
                     , f.duration
                     , f.mime_type
                  from audio.file f
                  join quran.ayah a using ( ayah_key )
                  join audio.recitation t using ( recitation_id )
                  join audio.reciter r using ( reciter_id )
                  left join audio.style s using ( style_id )
                 where f.is_enabled and f.format = 'ogg' ) ogg using ( ayah_key, recitation_id )")
        .joins("left join ( select t.recitation_id
                     , f.ayah_key
                     , concat( 'http://verses.quran.com/', concat_ws( '/', r.path, s.path, f.format, concat( replace( format('%3s', a.surah_id ), ' ', '0' ), replace( format('%3s', a.ayah_num ), ' ', '0' ), '.', f.format ) ) ) url
                     , f.duration
                     , f.mime_type
                  from audio.file f
                  join quran.ayah a using ( ayah_key )
                  join audio.recitation t using ( recitation_id )
                  join audio.reciter r using ( reciter_id )
                  left join audio.style s using ( style_id )
                 where f.is_enabled and f.format = 'mp3' ) mp3 using ( ayah_key, recitation_id )")
        .select("a.ayah_key
                     , ogg.url ogg_url
                     , ogg.duration ogg_duration
                     , ogg.mime_type ogg_mime_type
                     , mp3.url mp3_url
                     , mp3.duration mp3_duration
                     , mp3.mime_type mp3_mime_type")
        .where("audio.file.recitation_id = ?", audio_id)
        .where("a.ayah_key IN (?)", keys)
        .group("a.ayah_key, ogg.url, ogg.duration, ogg.mime_type, mp3.url, mp3.duration, mp3.mime_type, audio.file.file_id")
        .order("a.surah_id, a.ayah_num")
        .map do |ayah|
          {
            ayah_key: ayah.ayah_key,
            ogg:
                {
                    url: ayah.ogg_url,
                    duration: ayah.ogg_duration,
                    mime_type: ayah.ogg_mime_type
                },
            mp3:
                {
                    url: ayah.mp3_url,
                    duration: ayah.mp3_duration,
                    mime_type: ayah.mp3_mime_type
                }
          }
        end
    end
end
