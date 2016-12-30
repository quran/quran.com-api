# == Schema Information
#
# Table name: transliterations
#
#  id                  :integer          not null, primary key
#  resource_type       :string
#  resource_id         :integer
#  language_id         :integer
#  text                :text
#  resource_content_id :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class Transliteration < ApplicationRecord
  belongs_to :resource, polymorphic: true
  belongs_to :language
  belongs_to :resource_content
end
