# == Schema Information
#
# Table name: verses
#
#  id            :integer          not null, primary key
#  chapter_id    :integer
#  verse_number  :integer
#  verse_index   :integer
#  verse_key     :string
#  text_madani   :text
#  text_indopak  :text
#  text_simple   :text
#  juz_number    :integer
#  hizb_number   :integer
#  rub_number    :integer
#  sajdah        :string
#  sajdah_number :integer
#  page_number   :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Verse < ApplicationRecord
  include Searchable

  belongs_to :chapter, inverse_of: :verses, counter_cache: true
  has_many :tafsirs
  has_many :words
  has_many :media_contents, as: :resource
  has_many :translations, as: :resource
  has_many :transliterations, as: :resource
  has_many :audio_files, as: :resource
  has_many :recitations, through: :audio_files

  default_scope { order 'verse_number asc' }
end
