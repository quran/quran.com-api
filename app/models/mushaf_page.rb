# == Schema Information
#
# Table name: mushaf_pages
#
#  id             :bigint           not null, primary key
#  page_number    :integer
#  verse_mapping  :json
#  verses_count   :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  first_verse_id :integer
#  last_verse_id  :integer
#  mushaf_id      :integer
#
# Indexes
#
#  index_mushaf_pages_on_mushaf_id    (mushaf_id)
#  index_mushaf_pages_on_page_number  (page_number)
#
class MushafPage < ApplicationRecord
  include QuranNavigationSearchable

  belongs_to :mushaf
  has_many :verses, foreign_key: :page_number
  has_many :chapters, through: :verses
end
