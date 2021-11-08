# == Schema Information
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
require 'rails_helper'

RSpec.describe Morphology::GrammarConcept, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
