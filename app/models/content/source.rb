# == Schema Information
#
# Table name: source
#
#  source_id :integer          not null, primary key
#  name      :text             not null
#  url       :text
#

class Content::Source < ActiveRecord::Base
  self.table_name = 'source'

  has_many :resources, class_name: 'Content::Resource', foreign_key: 'source_id'
end
