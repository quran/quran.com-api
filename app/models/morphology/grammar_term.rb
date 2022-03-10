# == Schema Information
# Schema version: 20220123232023
#
# Table name: morphology_grammar_terms
#
#  id                   :bigint           not null, primary key
#  arabic_description   :text
#  arabic_grammar_name  :string
#  category             :string
#  english_description  :text
#  english_grammar_name :string
#  term                 :string
#  urdu_description     :text
#  urdu_grammar_name    :string
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
