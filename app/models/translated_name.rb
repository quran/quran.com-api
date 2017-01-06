# == Schema Information
#
# Table name: translated_names
#
#  id            :integer          not null, primary key
#  resource_type :string
#  resource_id   :integer
#  language_id   :integer
#  name          :string
#  language_name :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class TranslatedName < ApplicationRecord
  belongs_to :language
  belongs_to :resource, polymorphic: true

  class << self
    def filter_by_language_or_default(language)
      language = Language.find_by_iso_code(language || 'en')

      self.find_by(language: language) || self.find_by(language: Language.default)
    end
  end
end
