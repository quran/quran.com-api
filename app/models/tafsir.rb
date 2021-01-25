# frozen_string_literal: true

# == Schema Information
#
# Table name: tafsirs
#
#  id                  :integer          not null, primary key
#  verse_id            :integer
#  language_id         :integer
#  text                :text
#  language_name       :string
#  resource_content_id :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  resource_name       :string
#  verse_key           :string
#

class Tafsir < ApplicationRecord
  include Resourceable

  belongs_to :verse
  belongs_to :language
  has_many :foot_notes, as: :resource
end
