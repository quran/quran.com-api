class Content::Resource < ActiveRecord::Base
    extend Content

    self.table_name = 'resource'
    self.primary_key = 'resource_id'
end
