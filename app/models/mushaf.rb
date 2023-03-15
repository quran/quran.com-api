# frozen_string_literal: true
# == Schema Information
# Schema version: 20230313013539
#
# Table name: mushafs
#
#  id                  :bigint           not null, primary key
#  default_font_name   :string
#  description         :text
#  enabled             :boolean
#  is_default          :boolean          default(FALSE)
#  lines_per_page      :integer
#  name                :string
#  pages_count         :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  qirat_type_id       :integer
#  resource_content_id :bigint
#
# Indexes
#
#  index_mushafs_on_enabled              (enabled)
#  index_mushafs_on_is_default           (is_default)
#  index_mushafs_on_qirat_type_id        (qirat_type_id)
#  index_mushafs_on_resource_content_id  (resource_content_id)
#

class Mushaf < ApplicationRecord
  #TODO: add field in db instead of hard coding
  INDOPAK_MUSHAFS = [
    3, # pdms, disable now
    6, # 15 lines
    7, # 16 lines
    8, # 14 lines
    13, # QPC nastaleeq 15 lines
    14, # QPc Hafs nastaleeq 15 lines
    15 # QPc Hafs nastaleeq 16 lines
  ]

  scope :approved, -> { where enabled: true }
  has_many :mushaf_pages
  belongs_to :qirat_type

  def self.default
    where(is_default: true).first
  end

  def indopak?
    INDOPAK_MUSHAFS.include? id
  end

  def mushaf_type
    if indopak?
      'indopak'
    else
      'madani'
    end
  end
end
