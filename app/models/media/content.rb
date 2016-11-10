class Media::Content < ActiveRecord::Base
  extend Media

  self.primary_keys = :resource_id, :ayah_key

  belongs_to :resource, class_name: 'Media::Resource'
  belongs_to :ayah,     class_name: 'Quran::Ayah', foreign_key: 'ayah_key'
end
