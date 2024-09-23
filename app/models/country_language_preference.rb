# == Schema Information
# Schema version: 20240918072240
#
# Table name: country_language_preferences
#
#  id                         :bigint           not null, primary key
#  ayah_reflections_languages :string
#  country                    :string
#  default_reciter            :integer
#  default_tafsir_id          :integer
#  default_translation_ids    :string
#  default_wbw_language       :string
#  learning_plan_languages    :string
#  user_device_language       :string           not null
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  default_mushaf_id          :integer
#
# Foreign Keys
#
#  fk_rails_1069e91c22  (default_reciter => reciters.id)
#

class CountryLanguagePreference < ApplicationRecord
  belongs_to :reciter, foreign_key: :default_reciter, optional: true

  validates :user_device_language, presence: true

  # Add any additional validations or methods as needed
end
