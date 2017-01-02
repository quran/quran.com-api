# == Schema Information
#
# Table name: media.content
#
#  resource_id :integer          not null
#  ayah_key    :string
#  url         :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Media::Content < ActiveRecord::Base
  self.table_name = 'media.content'

  belongs_to :resource, class_name: 'Media::Resource'
  belongs_to :ayah,     class_name: 'Quran::Ayah', foreign_key: 'ayah_key'

  def as_json(options = {})
    super(include: :resource)
  end
end
