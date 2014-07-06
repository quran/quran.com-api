class Content::Author < ActiveRecord::Base
    extend Content

    self.table_name = 'author'
    self.primary_key = 'author_id'

    has_many :resources, class_name: 'Content::Resource', foreign_key: 'author_id'
end
