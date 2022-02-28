# == Schema Information
# Schema version: 20220109075422
#
# Table name: morphology_derived_words
#
#  id                 :integer          not null, primary key
#  verse_id           :integer
#  word_id            :integer
#  derived_word_id    :integer
#  word_verb_from_id  :integer
#  form_name          :string
#  en_transliteration :string
#  en_translation     :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_morphology_derived_words_on_derived_word_id    (derived_word_id)
#  index_morphology_derived_words_on_verse_id           (verse_id)
#  index_morphology_derived_words_on_word_id            (word_id)
#  index_morphology_derived_words_on_word_verb_from_id  (word_verb_from_id)
#

class Morphology::DerivedWord < ApplicationRecord
  belongs_to :verse
  belongs_to :word, class_name: 'Morphology::Word'
  belongs_to :derived_word, class_name: 'Word', optional: true
  belongs_to :word_verb_from, optional: true, class_name: 'Morphology::WordVerbForm'
end
