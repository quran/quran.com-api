# == Schema Information
#
# Table name: verse_pages
#
#  id          :bigint           not null, primary key
#  page_number :integer
#  mushaf_id   :integer
#  page_id     :integer
#  verse_id    :integer
#
# Indexes
#
#  index_verse_pages_on_page_number_and_mushaf_id  (page_number,mushaf_id)
#  index_verse_pages_on_verse_id                   (verse_id)
#

class VersePage < ApplicationRecord
  belongs_to :verse
end
