# frozen_string_literal: true
# == Schema Information
# Schema version: 20220109075422
#
# Table name: audio_recitations
#
#  id                  :integer          not null, primary key
#  name                :string
#  arabic_name         :string
#  relative_path       :string
#  format              :string
#  section_id          :integer
#  description         :text
#  files_count         :integer
#  resource_content_id :integer
#  recitation_style_id :integer
#  reciter_id          :integer
#  approved            :boolean
#  home                :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  priority            :integer
#  segments_count      :integer
#  files_size          :float
#  qirat_type_id       :integer
#  segment_locked      :boolean          default("false")
#
# Indexes
#
#  index_audio_recitations_on_approved             (approved)
#  index_audio_recitations_on_name                 (name)
#  index_audio_recitations_on_priority             (priority)
#  index_audio_recitations_on_recitation_style_id  (recitation_style_id)
#  index_audio_recitations_on_reciter_id           (reciter_id)
#  index_audio_recitations_on_relative_path        (relative_path)
#  index_audio_recitations_on_resource_content_id  (resource_content_id)
#  index_audio_recitations_on_section_id           (section_id)
#

class Audio::Recitation < ApplicationRecord
  include NameTranslateable
  include Resourceable

  has_many :chapter_audio_files, class_name: 'Audio::ChapterAudioFile', foreign_key: :audio_recitation_id
  has_many :related, class_name: 'Audio::RelatedRecitation', foreign_key: :audio_recitation_id
  has_many :related_recitations, class_name: 'Audio::Recitation', through: :related, source: :related_audio_recitation
  belongs_to :section, class_name: 'Audio::Section'
  belongs_to :recitation_style, optional: true
  belongs_to :qirat_type, optional: true
  belongs_to :reciter, optional: true

  scope :approved, -> { where(approved: true) }
end
