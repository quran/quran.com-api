# == Schema Information
#
# Table name: media.resource
#
#  resource_id :integer          not null, primary key
#  name        :string
#  url         :string
#  provider    :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Media::Resource < ActiveRecord::Base
  extend Media

  has_many :content
end
