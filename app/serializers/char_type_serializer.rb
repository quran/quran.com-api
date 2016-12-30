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

class CharTypeSerializer < ActiveModel::Serializer
  attributes :id, :name, :description
  has_one :parent
end
