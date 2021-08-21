class MushafPage < ApplicationRecord
  include QuranNavigationSearchable

  belongs_to :mushaf
  has_many :verses, foreign_key: :page_number
  has_many :chapters, through: :verses
end