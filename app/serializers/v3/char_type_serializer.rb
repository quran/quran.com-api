# == Schema Information
#
# Table name: char_types
#
#  id          :integer          not null, primary key
#  name        :string
#  parent_id   :integer
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class V3::CharTypeSerializer <  V3::ApplicationSerializer
  attributes :id, :name, :description
  has_one :parent
end
