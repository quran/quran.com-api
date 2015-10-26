# == Schema Information
#
# Table name: content.author
#
#  author_id :integer          not null, primary key
#  url       :text             is an Array
#  name      :text             not null
#

class Content::Author < ActiveRecord::Base
    extend Content

    self.table_name = 'author'
    self.primary_key = 'author_id'

    has_many :resources, class_name: 'Content::Resource', foreign_key: 'author_id'
end
