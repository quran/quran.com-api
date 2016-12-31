# == Schema Information
#
# Table name: verses
#
#  id           :integer          not null, primary key
#  chapter_id   :integer
#  verse_number :integer
#  verse_key    :string
#  text_madani  :text
#  text_indopak :text
#  text_simple  :text
#  juz_num      :integer
#  hizb_num     :integer
#  rub_num      :integer
#  sajdah       :integer
#  page_number  :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Verse < ApplicationRecord
  belongs_to :chapter, inverse_of: :verses, counter_cache: true
  has_many :tafsirs
  has_many :media_contents, as: :resource
  has_many :translations, as: :resource
  has_many :transliterations, as: :resource
end
