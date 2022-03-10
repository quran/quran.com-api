# == Schema Information
# Schema version: 20220123232023
#
# Table name: morphology_words
#
#  id                      :bigint           not null, primary key
#  case                    :string
#  case_reason             :string
#  description             :text
#  location                :string
#  words_count_for_lemma   :integer
#  words_count_for_root    :integer
#  words_count_for_stem    :integer
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  grammar_base_pattern_id :bigint
#  grammar_pattern_id      :bigint
#  verse_id                :bigint
#  word_id                 :bigint
#
# Indexes
#
#  index_morphology_words_on_grammar_base_pattern_id  (grammar_base_pattern_id)
#  index_morphology_words_on_grammar_pattern_id       (grammar_pattern_id)
#  index_morphology_words_on_location                 (location)
#  index_morphology_words_on_verse_id                 (verse_id)
#  index_morphology_words_on_word_id                  (word_id)
#
# Foreign Keys
#
#  fk_rails_3b86d16307  (word_id => words.id)
#  fk_rails_f421a8bac5  (verse_id => verses.id)
#

class Morphology::Word < ApplicationRecord
  belongs_to :word
  belongs_to :verse
  belongs_to :grammar_pattern, class_name: 'Morphology::GrammarPattern', optional: true
  belongs_to :grammar_base_pattern, class_name: 'Morphology::GrammarPattern', optional: true

  has_many :derived_words, class_name: 'Morphology::DerivedWord'
  has_many :word_segments, class_name: 'Morphology::WordSegment'
end
