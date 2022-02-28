# == Schema Information
# Schema version: 20220109075422
#
# Table name: morphology_words
#
#  id                      :integer          not null, primary key
#  word_id                 :integer
#  verse_id                :integer
#  grammar_pattern_id      :integer
#  grammar_base_pattern_id :integer
#  words_count_for_root    :integer
#  words_count_for_lemma   :integer
#  words_count_for_stem    :integer
#  location                :string
#  description             :text
#  case                    :string
#  case_reason             :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#
# Indexes
#
#  index_morphology_words_on_grammar_base_pattern_id  (grammar_base_pattern_id)
#  index_morphology_words_on_grammar_pattern_id       (grammar_pattern_id)
#  index_morphology_words_on_location                 (location)
#  index_morphology_words_on_verse_id                 (verse_id)
#  index_morphology_words_on_word_id                  (word_id)
#

class Morphology::Word < ApplicationRecord
  belongs_to :word
  belongs_to :verse
  belongs_to :grammar_pattern, class_name: 'Morphology::GrammarPattern', optional: true
  belongs_to :grammar_base_pattern, class_name: 'Morphology::GrammarPattern', optional: true

  has_many :derived_words, class_name: 'Morphology::DerivedWord'
  has_many :word_segments, class_name: 'Morphology::WordSegment'
end
