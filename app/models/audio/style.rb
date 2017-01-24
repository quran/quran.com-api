# == Schema Information
#
# Table name: style
#
#  style_id :integer          not null, primary key
#  path     :text             not null
#  slug     :text             not null
#  english  :text             not null
#  arabic   :text             not null
#

class Audio::Style < ActiveRecord::Base
    self.table_name = 'style'

    has_many :recitations, class_name: 'Audio::Recitation', foreign_key: 'style_id'
end
