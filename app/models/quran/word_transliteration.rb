# == Schema Information
#
# Table name: word_transliteration
#
#  transliteration_id :integer          not null, primary key
#  word_id            :integer
#  language_code      :string
#  value              :string
#
# Indexes
#
#  index_quran.word_transliteration_on_word_id  (word_id)
#

class Quran::WordTransliteration < ActiveRecord::Base
  belongs_to :word

  self.primary_key = 'transliteration_id'
end
