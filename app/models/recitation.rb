# == Schema Information
#
# Table name: recitations
#
#  id                  :integer          not null, primary key
#  reciter_id          :integer
#  resource_type       :string
#  resource_id         :integer
#  resource_content_id :integer
#  recitation_style_id :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class Recitation < ApplicationRecord
  belongs_to :reciter
  belongs_to :resource_content
  belongs_to :recitation_style
end
