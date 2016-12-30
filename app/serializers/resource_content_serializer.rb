# == Schema Information
#
# Table name: resource_contents
#
#  id               :integer          not null, primary key
#  approved         :boolean
#  author_id        :integer
#  cardinality_type :string
#  language_id      :integer
#  resource_type    :string
#  resource_id      :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class ResourceContentSerializer < ActiveModel::Serializer
  attributes :id, :approved, :cardinality_type
  has_one :author
  has_one :language
end
