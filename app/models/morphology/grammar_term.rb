# == Schema Information
# Schema version: 20220109075422
#
# Table name: morphology_grammar_terms
#
#  id                   :integer          not null, primary key
#  category             :string
#  term                 :string
#  arabic_grammar_name  :string
#  english_grammar_name :string
#  urdu_grammar_name    :string
#  arabic_description   :text
#  english_description  :text
#  urdu_description     :text
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
# Indexes
#
#  index_morphology_grammar_terms_on_category  (category)
#  index_morphology_grammar_terms_on_term      (term)
#

class Morphology::GrammarTerm < ApplicationRecord
  has_many :word_segments, class_name: 'Morphology::WordSegment'
  has_many :words, through: :word_segments, class_name: 'Morphology::Word'
end
