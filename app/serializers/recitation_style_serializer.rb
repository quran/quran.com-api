# == Schema Information
#
# Table name: recitation_styles
#
#  id         :integer          not null, primary key
#  style      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class RecitationStyleSerializer < ActiveModel::Serializer
  attributes :id, :style
end
