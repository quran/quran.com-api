# == Schema Information
# Schema version: 20220109075422
#
# Table name: rukus
#
#  id                :integer          not null, primary key
#  ruku_number       :integer
#  surah_ruku_number :integer
#  verse_mapping     :json
#  verses_count      :integer
#  first_verse_id    :integer
#  last_verse_id     :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_rukus_on_first_verse_id_and_last_verse_id  (first_verse_id,last_verse_id)
#  index_rukus_on_ruku_number                       (ruku_number)
#

class Ruku < ApplicationRecord
  include QuranNavigationSearchable

  has_many :verses, foreign_key: :ruku_number
end
