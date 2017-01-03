# == Schema Information
#
# Table name: chapter_infos
#
#  id                  :integer          not null, primary key
#  chapter_id          :integer
#  text                :text
#  source              :string
#  short_text          :text
#  language_id         :integer
#  resource_content_id :integer
#  language_name       :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class ChapterInfo < ApplicationRecord
  belongs_to :chapter, inverse_of: :chapter_infos
  belongs_to :language
  belongs_to :resource_content #, as: :resource

  class << self
    def filter_by_language_or_default(language)
      self.find_by(language: language) || self.find_by(language: Language.default)
    end
  end
end
