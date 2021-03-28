# == Schema Information
#
# Table name: audio_recitations
#
#  id                  :bigint           not null, primary key
#  arabic_name         :string
#  description         :text
#  file_formats        :string
#  home                :integer
#  name                :string
#  relative_path       :string
#  torrent_filename    :string
#  torrent_info_hash   :string
#  torrent_leechers    :integer          default(0)
#  torrent_seeders     :integer          default(0)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  resource_content_id :integer
#  section_id          :integer
#
class Audio::Recitation < ApplicationRecord
  include NameTranslateable
  include Resourceable

  has_many :chapter_audio_files, class_name: 'Audio::ChapterAudioFile', foreign_key: :audio_recitation_id
  has_many :related_recitations, class_name: 'Audio::RelatedRecitation', foreign_key: :audio_recitation_id
  belongs_to :section, class_name: 'Audio::Section'
  belongs_to :recitation_style, optional: true
end
