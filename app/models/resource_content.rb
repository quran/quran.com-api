# frozen_string_literal: true
# == Schema Information
#
# Table name: resource_contents
#
#  id                    :integer          not null, primary key
#  approved              :boolean
#  author_id             :integer
#  data_source_id        :integer
#  author_name           :string
#  resource_type         :string
#  sub_type              :string
#  name                  :string
#  description           :text
#  cardinality_type      :string
#  language_id           :integer
#  language_name         :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  slug                  :string
#  mobile_translation_id :integer
#

class ResourceContent < ApplicationRecord
  include LanguageFilterable

  scope :translations, -> { where sub_type: [SubType::Translation, SubType::Transliteration] }
  scope :media, -> { where sub_type: SubType::Video }
  scope :tafsirs, -> { where sub_type: SubType::Tafsir }
  scope :chapter_info, -> { where sub_type: SubType::Info }
  scope :one_verse, -> { where cardinality_type: CardinalityType::OneVerse }
  scope :one_chapter, -> { where cardinality_type: CardinalityType::OneChapter }
  scope :approved, -> { where approved: true }

  module CardinalityType
    OneVerse = '1_ayah'.freeze
    OneWord = '1_word'.freeze
    NVerse = 'n_ayah'.freeze
    OneChapter = '1_chapter'.freeze
  end

  module ResourceType
    Audio = 'audio'.freeze
    Content = 'content'.freeze
    Quran = 'quran'.freeze
    Media = 'media'.freeze
  end

  module SubType
    Translation = 'translation'.freeze
    Tafsir = 'tafsir'.freeze
    Transliteration = 'transliteration'.freeze
    Font = 'font'.freeze
    Image = 'image'.freeze
    Info = 'info'.freeze
    Video = 'video'.freeze
  end

  belongs_to :author
  belongs_to :data_source
  has_one :resource_content_stat

  def increment_download_count!
     stats = resource_content_stat || create_resource_content_stat
     stats.update_column :download_count, stats.download_count.to_i + 1
  end
end
