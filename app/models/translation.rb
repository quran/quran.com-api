# frozen_string_literal: true

# == Schema Information
#
# Table name: translations
#
#  id                  :integer          not null, primary key
#  language_id         :integer
#  text                :string
#  resource_content_id :integer
#  resource_type       :string
#  resource_id         :integer
#  language_name       :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  resource_name       :string
#

class Translation < ApplicationRecord
  include LanguageFilterable
  include TranslationSearchable

  belongs_to :verse
  belongs_to :resource_content
  belongs_to :language
  has_many :foot_notes, as: :resource

  scope :approved, -> {joins(:resource_content).where('resource_contents.approved = ?', true)}

  def es_analyzer
  end
end
