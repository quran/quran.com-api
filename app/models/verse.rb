# frozen_string_literal: true

# == Schema Information
#
# Table name: verses
#
#  id             :integer          not null, primary key
#  chapter_id     :integer
#  verse_number   :integer
#  verse_index    :integer
#  verse_key      :string
#  text_madani    :text
#  text_indopak   :text
#  text_simple    :text
#  juz_number     :integer
#  hizb_number    :integer
#  rub_number     :integer
#  sajdah         :string
#  sajdah_number  :integer
#  page_number    :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  image_url      :text
#  image_width    :integer
#  verse_root_id  :integer
#  verse_lemma_id :integer
#  verse_stem_id  :integer
#

class Verse < ApplicationRecord
  include QuranSearchable

  belongs_to :chapter, inverse_of: :verses, counter_cache: true
  belongs_to :verse_root
  belongs_to :verse_lemma
  belongs_to :verse_stem

  has_many :tafsirs
  has_many :words
  #has_many :media_contents, as: :resource
  has_many :translations
  has_many :audio_files, as: :resource
  has_many :recitations, through: :audio_files
  has_many :roots, through: :words

  # For eager loading
  has_one  :audio, class_name: 'AudioFile', as: :resource

  default_scope { order 'verse_number asc' }

  attr_accessor :highlighted_text

  def self.find_by_id_or_key(id)
    where(verse_key: id).or(where(id: id)).first
  end

  def highlighted_text
    @highlighted_text || text_madani
  end
end
