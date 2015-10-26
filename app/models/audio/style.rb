# == Schema Information
#
# Table name: audio.style
#
#  style_id :integer          not null, primary key
#  path     :text             not null
#  slug     :text             not null
#  english  :text             not null
#  arabic   :text             not null
#

class Audio::Style < ActiveRecord::Base
    extend Audio

    self.table_name = 'style'
    self.primary_key = 'style_id'

    has_many :recitations, class_name: 'Audio::Recitation', foreign_key: 'style_id'
end
