# frozen_string_literal: true

# == Schema Information
#
# Table name: mushafs
#
#  id                  :bigint           not null, primary key
#  default_font_name   :string
#  description         :text
#  enabled             :boolean
#  is_default          :boolean          default(FALSE)
#  lines_per_page      :integer
#  name                :string           not null
#  pages_count         :integer
#  qirat_type_id       :integer
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
end
