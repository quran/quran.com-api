# == Schema Information
#
# Table name: corpus_morphology_terms
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
#  index_corpus_morphology_terms_on_category  (category)
#  index_corpus_morphology_terms_on_term      (term)
#
require 'rails_helper'

RSpec.describe Corpus::MorphologyTerm, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
