# frozen_string_literal: true

# == Schema Information
#
# Table name: chapters
#
#  id               :integer          not null, primary key
#  bismillah_pre    :boolean
#  chapter_number   :integer
#  name_arabic      :string
#  name_complex     :string
#  name_simple      :string
#  pages            :string
#  revelation_order :integer
#  revelation_place :string
#  verses_count     :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_chapters_on_chapter_number  (chapter_number)
#

class Chapter < ApplicationRecord
  include Slugable
  include QuranNavigationSearchable
  include NameTranslateable

  has_many :verses
  has_many :chapter_infos

  serialize :pages

  default_scope { order 'chapter_number asc' }
end
