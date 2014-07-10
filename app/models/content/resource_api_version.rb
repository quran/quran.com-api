class Content::ResourceAPIVersion < ActiveRecord::Base
    extend Content

    self.table_name = 'resource_api_version'
    self.primary_key = 'resource_id'

    belongs_to :resource, class_name: 'Content::Resource'

    
end
# notes:
# - this table was used for migrating from an old database
# - the key column to pay attention to here is "v2_is_enabled"
