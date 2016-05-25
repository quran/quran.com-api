# == Schema Information
#
# Table name: audio.file
#
#  file_id       :integer          not null, primary key
#  recitation_id :integer          not null
#  ayah_key      :text             not null
#  format        :text             not null
#  duration      :float
#  mime_type     :text             not null
#  is_enabled    :boolean          default(TRUE), not null
#  url           :text
#  segments      :text
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

    super(only: [:reciter_id, :format, :duration, :mime_type, :url], include: :reciter).merge(
      segments: segments_encrypted
    # url: "http://verses.quran.com/#{reciter.path}/#{format}/#{surah.to_s.rjust(3, "0")}#{ayah.to_s.rjust(3, "0")}.#{format}"
    )
  end
end
