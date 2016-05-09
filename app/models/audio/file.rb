# == Schema Information
#
# Table name: audio.file
#
#  file_id       :integer          not null, primary key
#  recitation_id :integer          not null
#  ayah_key      :text             not null
#  format        :text             not null
#  duration      :float            not null
#  mime_type     :text             not null
#  is_enabled    :boolean          default(TRUE), not null
#

require 'base64'
require 'gibberish'

class Audio::File < ActiveRecord::Base
    extend Audio

    self.table_name = 'file'
    self.primary_key = 'file_id'

    belongs_to :ayah,       class_name: 'Quran::Ayah'
    belongs_to :recitation, class_name: 'Audio::Recitation'
    has_one :reciter, class_name: 'Audio::Reciter', through: :recitation

    scope :ogg, -> { where(format: 'ogg') }
    scope :mp3, -> { where(format: 'mp3') }

    def self.bucket_audio(audio_id, keys)
        secret = ENV['SEGMENTS_KEY'] || '¯\_(ツ)_/¯'

        self
        .joins("join quran.ayah a using ( ayah_key )")
        .joins("left join ( select t.recitation_id
                     , f.ayah_key
                  -- , concat( 'http://verses.quran.com/', concat_ws( '/', r.path, s.path, f.format, concat( replace( format('%3s', a.surah_id ), ' ', '0' ), replace( format('%3s', a.ayah_num ), ' ', '0' ), '.', f.format ) ) ) url
                     , f.url
                     , f.duration
                     , f.mime_type
                     , f.segments
                  from audio.file f
                  join quran.ayah a using ( ayah_key )
                  join audio.recitation t using ( recitation_id )
                  join audio.reciter r using ( reciter_id )
                  left join audio.style s using ( style_id )
                 where f.is_enabled and f.format = 'ogg' ) ogg using ( ayah_key, recitation_id )")
        .joins("left join ( select t.recitation_id
                     , f.ayah_key
                  -- , concat( 'http://verses.quran.com/', concat_ws( '/', r.path, s.path, f.format, concat( replace( format('%3s', a.surah_id ), ' ', '0' ), replace( format('%3s', a.ayah_num ), ' ', '0' ), '.', f.format ) ) ) url
                     , f.url
                     , f.duration
                     , f.mime_type
                     , f.segments
                  from audio.file f
                  join quran.ayah a using ( ayah_key )
                  join audio.recitation t using ( recitation_id )
                  join audio.reciter r using ( reciter_id )
                  left join audio.style s using ( style_id )
                 where f.is_enabled and f.format = 'mp3' ) mp3 using ( ayah_key, recitation_id )")
        .select("a.ayah_key
                     , ogg.segments ogg_segments
                     , ogg.url ogg_url
                     , ogg.duration ogg_duration
                     , ogg.mime_type ogg_mime_type
                     , mp3.segments mp3_segments
                     , mp3.url mp3_url
                     , mp3.duration mp3_duration
                     , mp3.mime_type mp3_mime_type")
        .where("audio.file.recitation_id = ?", audio_id)
        .where("a.ayah_key IN (?)", keys)
        .group("a.ayah_key, ogg.url, ogg.duration, ogg.mime_type, ogg.segments, mp3.url, mp3.duration, mp3.mime_type, mp3.segments, audio.file.file_id")
        .order("a.surah_id, a.ayah_num")
        .map do |ayah|
          cipher = Gibberish::AES.new(secret)
          {
            ayah_key: ayah.ayah_key,
            ogg:
                {
                    url: ayah.ogg_url,
                    segments: Base64.encode64(cipher.encrypt((if ayah.ogg_segments then ayah.ogg_segments else '[]' end))),
                    duration: ayah.ogg_duration,
                    mime_type: ayah.ogg_mime_type
                },
            mp3:
                {
                    url: ayah.mp3_url,
                    segments: Base64.encode64(cipher.encrypt((if ayah.mp3_segments then ayah.mp3_segments else '[]' end))),
                    duration: ayah.mp3_duration,
                    mime_type: ayah.mp3_mime_type
                }
          }
        end.uniq{|a| a[:ayah_key]}
    end

  def as_json(options = {})
    surah = ayah_key.split(':')[0]
    ayah = ayah_key.split(':')[1]

    secret = ENV['SEGMENTS_KEY'] || '¯\_(ツ)_/¯'
    cipher = Gibberish::AES.new(secret)
    scrambled = Base64.encode64(cipher.encrypt((if segments then segments else '[]' end)))

    super(only: [:reciter_id, :format, :duration, :mime_type, :url], include: :reciter).merge(
      segments: scrambled
    # url: "http://verses.quran.com/#{reciter.path}/#{format}/#{surah.to_s.rjust(3, "0")}#{ayah.to_s.rjust(3, "0")}.#{format}"
    )
  end
end
