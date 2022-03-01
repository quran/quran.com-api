# == Schema Information
# Schema version: 20220109075422
#
# Table name: morphology_grammar_patterns
#
#  id         :integer          not null, primary key
#  english    :string
#  arabic     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_morphology_grammar_patterns_on_arabic   (arabic)
#  index_morphology_grammar_patterns_on_english  (english)
#

class Morphology::GrammarPattern < ApplicationRecord
end
