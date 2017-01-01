# == Schema Information
#
# Table name: audio_files
#
#  id                  :integer          not null, primary key
#  resource_type       :string
#  resource_id         :integer
#  url                 :text
#  duration            :integer
#  segments            :text
#  encrypted_setments  :text
#  mime_type           :string
#  format              :string
#  recitation_id       :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class AudioFile < ApplicationRecord
  belongs_to :resource, polymorphic: true
  belongs_to :recitation

  serialize :segments
end