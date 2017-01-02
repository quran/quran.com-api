# == Schema Information
#
# Table name: reciters
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class V3::ReciterSerializer < V3::ApplicationSerializer
  attributes :id, :name
end
