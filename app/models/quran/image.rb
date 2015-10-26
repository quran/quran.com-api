# == Schema Information
#
# Table name: quran.image
#
#  resource_id :integer          not null, primary key
#  ayah_key    :text             not null, primary key
#  url         :text             not null
#  alt         :text             not null
#  width       :integer          not null
#

class Quran::Image < ActiveRecord::Base
    extend Quran

    self.table_name = 'image'
    self.primary_keys = :resource_id, :ayah_key

    belongs_to :resource, class_name: 'Content::Resource'
    belongs_to :ayah, class_name: 'Quran::Ayah'
end

