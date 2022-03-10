# == Schema Information
# Schema version: 20220123232023
#
# Table name: morphology_grammar_concepts
#
#  id         :bigint           not null, primary key
#  arabic     :string
#  english    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_morphology_grammar_concepts_on_arabic   (arabic)
#  index_morphology_grammar_concepts_on_english  (english)
#

class Morphology::GrammarConcept < ApplicationRecord
  has_many :word_segments, class_name: 'Morphology::WordSegment'
  has_many :words, through: :word_segments, class_name: 'Morphology::Word'
end
