# == Schema Information
#
# Table name: file
#
#  file_id        :integer          not null, primary key
#  recitation_id  :integer          not null
#  ayah_key       :text             not null
#  format         :text             not null
#  duration       :float
#  mime_type      :text             not null
#  is_enabled     :boolean          default(TRUE), not null
#  url            :text
#  segments_stats :json
#  segments       :text             is an Array
#

class Audio::File < ActiveRecord::Base
  self.table_name = 'file'

  belongs_to :ayah,       class_name: 'Quran::Ayah'
  belongs_to :recitation, class_name: 'Audio::Recitation'
  has_one :reciter, class_name: 'Audio::Reciter', through: :recitation

  scope :mp3, -> { where(format: 'mp3') }

  def as_json(options = {})
    surah = ayah_key.split(':')[0]
    ayah = ayah_key.split(':')[1]


    super(only: [:duration, :url, :segments])
  end
end
