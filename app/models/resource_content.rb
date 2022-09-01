# frozen_string_literal: true
# == Schema Information
# Schema version: 20220325102524
#
# Table name: resource_contents
#
#  id                     :integer          not null, primary key
#  approved               :boolean
#  author_name            :string
#  cardinality_type       :string
#  description            :text
#  language_name          :string
#  meta_data              :jsonb
#  name                   :string
#  priority               :integer
#  records_count          :integer          default(0)
#  resource_info          :text
#  resource_type          :string
#  resource_type_name     :string
#  slug                   :string
#  sqlite_db              :string
#  sqlite_db_generated_at :datetime
#  sub_type               :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  author_id              :integer
#  data_source_id         :integer
#  language_id            :integer
#  mobile_translation_id  :integer
#  resource_id            :string
#
# Indexes
#
#  index_resource_contents_on_approved               (approved)
#  index_resource_contents_on_author_id              (author_id)
#  index_resource_contents_on_cardinality_type       (cardinality_type)
#  index_resource_contents_on_data_source_id         (data_source_id)
#  index_resource_contents_on_language_id            (language_id)
#  index_resource_contents_on_meta_data              (meta_data) USING gin
#  index_resource_contents_on_mobile_translation_id  (mobile_translation_id)
#  index_resource_contents_on_priority               (priority)
#  index_resource_contents_on_resource_id            (resource_id)
#  index_resource_contents_on_resource_type_name     (resource_type_name)
#  index_resource_contents_on_slug                   (slug)
#  index_resource_contents_on_sub_type               (sub_type)
#

class ResourceContent < ApplicationRecord
  include LanguageFilterable
  include NameTranslateable

  scope :translations, -> { where sub_type: [SubType::Translation, SubType::Transliteration] }
  scope :media, -> { where sub_type: SubType::Video }
  scope :tafsirs, -> { where sub_type: SubType::Tafsir }
  scope :chapter_info, -> { where sub_type: SubType::Info }
  scope :one_verse, -> { where cardinality_type: CardinalityType::OneVerse }
  scope :one_chapter, -> { where cardinality_type: CardinalityType::OneChapter }
  scope :approved, -> { where approved: true }
  scope :recitations, -> { where sub_type: SubType::Audio }

  module CardinalityType
    OneVerse = '1_ayah'
    OneWord = '1_word'
    NVerse = 'n_ayah'
    OneChapter = '1_chapter'
  end

  module ResourceType
    Audio = 'audio'
    Content = 'content'
    Quran = 'quran'
    Media = 'media'
  end

  module SubType
    Translation = 'translation'
    Tafsir = 'tafsir'
    Transliteration = 'transliteration'
    Font = 'font'
    Image = 'image'
    Info = 'info'
    Video = 'video'
    Audio = 'audio'
    Data = 'data' # General data, ()Mushaf layout info for now)
  end

  belongs_to :author
  belongs_to :data_source
  has_one :resource_content_stat

  def increment_download_count!
    stats = resource_content_stat || create_resource_content_stat
    stats.update_column :download_count, stats.download_count.to_i + 1
  end

  def self.changes(updated_after)
    if updated_after.present?
      where("updated_at > ?", updated_after)
    else
      all
    end
  end

  def self.filter_subtype(type = nil)
    if type.present?
      where sub_type: type
    else
      all
    end
  end
end
