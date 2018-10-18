# frozen_string_literal: true

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

class V3::VerseSerializer < V3::ApplicationSerializer
  attributes :id,
             :verse_number,
             :chapter_id,
             :verse_key,
             :text_madani,
             :text_indopak,
             :text_simple,
             :juz_number,
             :hizb_number,
             :rub_number,
             :sajdah,
             :sajdah_number,
             :page_number

  has_one :audio, if: :render_audio?, serializer: V3::AudioFileSerializer

  has_many :translations, if: :render_translations?

  # TODO: Should always return media
  # has_many :media_contents, if: :render_media? do
  #   object
  #     .media_contents
  #     .joins(:resource_content)
  #     .where(resource_content_id: scope[:media])
  # end
  has_many :media_contents

  has_many :words, unless: :render_images?

  attribute :image, key: :image, if: :render_images? do
    { url: object.image_url, width: object.image_width }
  end

  def render_images?
    scope[:text_type] == 'image'
  end

  def render_audio?
    scope[:recitation].present?
  end

  def render_translations?
    scope[:translations].present?
  end

  def render_media?
    scope[:media].present?
  end

  def audio
    object.audio_files.first
  end
end
