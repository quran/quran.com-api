# == Schema Information
#
# Table name: content.surah_infos
#
#  id                :integer          not null, primary key
#  language_code     :string
#  description       :text
#  surah_id          :integer
#  content_source    :text
#  short_description :text
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class Content::SurahInfo < ActiveRecord::Base
  extend Content

  self.table_name = 'surah_infos'
  self.primary_key = 'id'

  belongs_to :language, class_name: 'Locale::Language', foreign_key: 'language_code'
  belongs_to :surah, class_name: 'Quran::Surah'

  validates :language, :surah, presence: true

  def as_json(options = {})
    super(options.merge(only: [:language_code, :description, :content_source, :short_description, :surah_id]))
  end
end
