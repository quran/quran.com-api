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

class Audio::File < ActiveRecord::Base
  extend Audio

  self.table_name = 'file'
  self.primary_key = 'file_id'

  belongs_to :ayah,       class_name: 'Quran::Ayah'
  belongs_to :recitation, class_name: 'Audio::Recitation'
  has_one :reciter, class_name: 'Audio::Reciter', through: :recitation

  scope :ogg, -> { where(format: 'ogg') }
  scope :mp3, -> { where(format: 'mp3') }

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
