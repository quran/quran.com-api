# == Schema Information
#
# Table name: audio_files
#
#  id                  :integer          not null, primary key
#  resource_type       :string
#  resource_id         :integer
#  url                 :text
#  resource_content_id :integer
#  duration            :integer
#  segments            :text
#  encrypted_setments  :text
#  mime_type           :string
#  format              :string
#  recitation_id       :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class AudioFileSerializer < ActiveModel::Serializer
  attributes :id, :url, :duration, :setments, :encrypted_setments, :format
  has_one :resource
  has_one :resource_content
  has_one :recitation
end
