# == Schema Information
#
# Table name: recitation_styles
#
#  id         :integer          not null, primary key
#  style      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class V3::RecitationStyleSerializer < V3::ApplicationSerializer
  attributes :id, :style
end
