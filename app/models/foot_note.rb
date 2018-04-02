# frozen_string_literal: true

# == Schema Information
#
# Table name: foot_notes
#
#  id                  :integer          not null, primary key
#  resource_type       :string
#  resource_id         :integer
#  text                :text
#  language_id         :integer
#  language_name       :string
#  resource_content_id :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class FootNote < ApplicationRecord
  belongs_to :resource, polymorphic: true
  belongs_to :language
  belongs_to :resource_content
end
