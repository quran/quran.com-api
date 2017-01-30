# == Schema Information
#
# Table name: authors
#
#  id         :integer          not null, primary key
#  name       :string
#  url        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class V3::AuthorSerializer <  V3::ApplicationSerializer
  attributes :name, :url, :id
end
