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
  # TODO: figure out es
  # include Searchable

  belongs_to :resource, polymorphic: true
  belongs_to :resource_content
  has_many :foot_notes, as: :resource
end
