# == Schema Information
# Schema version: 20240918072240
#
# Table name: country_language_preferences
#
#  id                         :bigint           not null, primary key
#  ayah_reflections_languages :string
#  country                    :string
#  default_reciter            :integer
#  default_translation_ids    :string
#  default_wbw_language       :string
#  learning_plan_languages    :string
#  user_device_language       :string           not null
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  default_mushaf_id          :integer
#  default_tafsir_id          :integer
#
# Foreign Keys
#
#  fk_rails_1069e91c22  (default_reciter => reciters.id) ON DELETE => cascade
#  fk_rails_508ee899a1  (user_device_language => languages.iso_code) ON DELETE => cascade
#  fk_rails_90bfd196ab  (default_tafsir_id => resource_contents.id) ON DELETE => cascade
#  fk_rails_9b4f468673  (default_wbw_language => languages.iso_code) ON DELETE => cascade
#  fk_rails_fbdc70f32a  (default_mushaf_id => mushafs.id) ON DELETE => cascade
#

class CountryLanguagePreference < ApplicationRecord
  belongs_to :reciter, foreign_key: :default_reciter, optional: true
  belongs_to :language, foreign_key: :user_device_language, primary_key: :iso_code, optional: true
  belongs_to :wbw_language, class_name: 'Language', foreign_key: :default_wbw_language, primary_key: :iso_code, optional: true
  belongs_to :mushaf, foreign_key: :default_mushaf_id, optional: true
  belongs_to :tafsir, class_name: 'ResourceContent', foreign_key: :default_tafsir_id, optional: true

  validates :user_device_language, presence: true

  scope :with_includes, -> { 
    includes(:reciter, :language, :wbw_language, :mushaf, :tafsir)
    .where(mushafs: { enabled: true }, resource_contents: { approved: true })
  }

end
