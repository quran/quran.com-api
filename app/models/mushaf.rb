# frozen_string_literal: true
# == Schema Information
# Schema version: 20220109075422
#
# Table name: mushafs
#
#  id                  :integer          not null, primary key
#  name                :string           not null
#  description         :text
#  lines_per_page      :integer
#  is_default          :boolean          default("false")
#  default_font_name   :string
#  pages_count         :integer
#  qirat_type_id       :integer
#  enabled             :boolean
#  resource_content_id :integer
#
# Indexes
#
#  index_mushafs_on_enabled        (enabled)
#  index_mushafs_on_is_default     (is_default)
#  index_mushafs_on_qirat_type_id  (qirat_type_id)
#

class Mushaf < ApplicationRecord
  scope :approved, -> { where enabled: true }
  has_many :mushaf_pages
  belongs_to :qirat_type

  def self.default
    where(is_default: true).first
  end
end
