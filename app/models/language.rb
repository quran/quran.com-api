# == Schema Information
#
# Table name: languages
#
#  id                  :integer          not null, primary key
#  name                :string
#  iso_code            :string
#  native_name         :string
#  direction           :string
#  es_analyzer_default :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class Language < ApplicationRecord
  has_many :translated_names, as: :resource

  def self.default
    Language.find_by_iso_code(:en)
  end
end

