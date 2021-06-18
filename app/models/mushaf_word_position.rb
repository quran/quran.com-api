# == Schema Information
#
# Table name: mushaf_word_positions
#
#  id                :bigint           not null, primary key
#  char_type_name    :string
#  line_number       :integer
#  page_number       :integer
#  position_in_line  :integer
#  position_in_page  :integer
#  position_in_verse :integer
#  text              :text
#  char_type_id      :integer
#  mushaf_id         :integer
#  verse_id          :integer
#  word_id           :integer
#
# Indexes
#
#  index_mushaf_word_positions_on_mushaf_id_and_word_id  (mushaf_id,word_id)
#  index_on_mushad_word_position                         (mushaf_id,verse_id,position_in_verse)
#
class MushafWordPosition < ApplicationRecord
  belongs_to :word
  belongs_to :mushaf
end
