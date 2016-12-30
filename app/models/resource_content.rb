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

class ResourceContent < ApplicationRecord
  belongs_to :author
  belongs_to :language
end
