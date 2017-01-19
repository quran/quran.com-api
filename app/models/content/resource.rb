# == Schema Information
#
# Table name: content.resource
#
#  resource_id      :integer          not null, primary key
#  type             :text             not null
#  sub_type         :text             not null
#  cardinality_type :text             default("1_ayah"), not null
#  language_code    :text             not null
#  slug             :text             not null
#  is_available     :boolean          default(TRUE), not null
#  description      :text
#  author_id        :integer
#  source_id        :integer
#  name             :text             not null
#

class Content::Resource < ActiveRecord::Base
  extend Content

  self.table_name = 'resource'
  self.primary_key = 'resource_id'

  self.inheritance_column = nil

  scope :quran,   -> { where(type: 'quran') }
  scope :content, -> { where(type: 'content') }
  scope :enabled, -> { joins(:_resource_api_version).where(resource_api_version: {v2_is_enabled: 't' }) }

  belongs_to :author, class_name: 'Content::Author', foreign_key: 'author_id'
  belongs_to :source, class_name: 'Content::Source', foreign_key: 'source_id'
  belongs_to :language, class_name: 'Locale::Language', foreign_key: 'language_code'

  # maybe make the block below a polymorphic class, accessible via 'content' or something
  # dunno wth polymorphic relationships really are, so maybe not -- fancy crap not worth a brain cell
  has_many :_image, class_name: 'Quran::Image', foreign_key: 'resource_id'
  has_many :_text, class_name: 'Quran::Text', foreign_key: 'resource_id'
  has_many :_word_font, class_name: 'Quran::WordFont', foreign_key: 'resource_id'
  has_many :_tafsir, class_name: 'Content::Tafsir', foreign_key: 'resource_id'
  has_many :_translation, class_name: 'Content::Translation', foreign_key: 'resource_id'
  has_many :_transliteration, class_name: 'Content::Transliteration', foreign_key: 'resource_id'
  has_one  :_resource_api_version, class_name: 'Content::ResourceAPIVersion', foreign_key: 'resource_id'


  # OPTIONS RELATED
  def self.list_quran_options
    self.joins(:_resource_api_version)
    .select([:resource_id, :sub_type, :cardinality_type, :slug, :is_available, :description, :name].map{ |term| "content.resource.#{term}" }.join(', '))
    .where("content.resource.type = 'quran' AND content.resource_api_version.v2_is_enabled = 't'")
  end

  def self.list_content_options
    self.joins(:_resource_api_version)
    .select([:resource_id, :sub_type, :cardinality_type, :language_code, :slug, :is_available, :description, :name].map{ |term| "content.resource.#{term}" }.join(', '))
    .where("content.resource_api_version.v2_is_enabled = 't' AND content.resource.type = 'content'")
  end

  def self.list_language_options
    self.enabled.joins(:language)
    .select("language.language_code,language.unicode, language.english, language.direction")
    .group("language.language_code, language.unicode, language.english, language.direction")
    .order("language.language_code")
  end

  def view_json
    as_json(only: [:name, :description, :is_available, :slug]).merge(
      language: language_code,
      cardinality: cardinality_type,
      type: sub_type,
      id: resource_id
    )
  end
end
