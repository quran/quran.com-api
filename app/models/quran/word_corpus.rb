# == Schema Information
#
# Table name: word_corpus
#
#  location            :integer          not null
#  word_id             :integer
#  description         :string
#  transliteration     :string
#  image_src           :string
#  segment             :string
#  segment_class       :string
#  segment_description :string
#  segment_translation :string
#  grammar             :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_quran.word_corpus_on_word_id  (word_id)
#

class Quran::WordCorpus < ActiveRecord::Base
end
