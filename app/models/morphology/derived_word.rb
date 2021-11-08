# == Schema Information
#
# Table name: morphology_derived_words
#
#  id                 :bigint           not null, primary key
#  en_translation     :string
#  en_transliteration :string
#  form_name          :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  derived_word_id    :bigint
#  verse_id           :bigint
#  word_id            :bigint
#  word_verb_from_id  :bigint
#
# Indexes
#
#  index_morphology_derived_words_on_derived_word_id    (derived_word_id)
#  index_morphology_derived_words_on_verse_id           (verse_id)
#  index_morphology_derived_words_on_word_id            (word_id)
#  index_morphology_derived_words_on_word_verb_from_id  (word_verb_from_id)
#
# Foreign Keys
#
#  fk_rails_...  (verse_id => verses.id)
#  fk_rails_...  (word_id => words.id)
#
class Morphology::DerivedWord < ApplicationRecord
  belongs_to :verse
  belongs_to :word, class_name: 'Morphology::Word'
  belongs_to :derived_word, class_name: 'Word', optional: true
  belongs_to :word_verb_from, optional: true, class_name: 'Morphology::WordVerbForm'
end
