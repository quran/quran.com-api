# == Schema Information
#
# Table name: image
#
#  resource_id :integer          not null
#  ayah_key    :text             not null
#  url         :text             not null
#  alt         :text             not null
#  width       :integer          not null
#

class Quran::Image < ActiveRecord::Base
  self.table_name = 'image'

  belongs_to :resource, class_name: 'Content::Resource'
  belongs_to :ayah, class_name: 'Quran::Ayah'
end
