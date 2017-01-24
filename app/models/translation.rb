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
#

class Translation < ApplicationRecord
  include LanguageFilterable

  belongs_to :resource, polymorphic: true
  belongs_to :resource_content
  has_many :foot_notes, as: :resource

  def as_indexed_json(options)
    hash = self.as_json(
        only: [:id, :verse_key, :text_madani, :text_indopak, :text_simple],
        methods: [:chapter_name]
    )

    #translations.joins(:language).each do |trans|
    #  hash["trasn_#{trans.language.iso_code}"] = trans.text
    #end

    hash
  end
end
