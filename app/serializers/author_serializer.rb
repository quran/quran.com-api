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

class AuthorSerializer < ActiveModel::Serializer
  attributes :id, :name, :url
end
