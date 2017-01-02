# == Schema Information
#
# Table name: quran.image
#
#  resource_id :integer          not null
#  ayah_key    :text             not null
#  url         :text             not null
#  alt         :text             not null
#  width       :integer          not null
#

class Image < ApplicationRecord
  self.table_name = 'quran.image'
  belongs_to :resource_content
  belongs_to :verse
end

