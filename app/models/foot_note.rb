# frozen_string_literal: true

# == Schema Information
# Schema version: 20230313013539
#
# Table name: foot_notes
#
#  id                  :integer          not null, primary key
#  language_name       :string
#  resource_type       :string
#  text                :text
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  language_id         :integer
#  resource_content_id :integer
#  resource_id         :integer
#
# Indexes
#
#  index_foot_notes_on_language_id          (language_id)
#  index_foot_notes_on_resource             (resource_type,resource_id)
#  index_foot_notes_on_resource_content_id  (resource_content_id)
#

class FootNote < ApplicationRecord
  include Resourceable

  belongs_to :verse
  belongs_to :language
end
