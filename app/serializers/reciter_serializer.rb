# == Schema Information
#
# Table name: reciters
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ReciterSerializer < ActiveModel::Serializer
  attributes :id, :name
end
