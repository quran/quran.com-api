# == Schema Information
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
#  fk_rails_...  (verse_id => verses.id)
#  fk_rails_...  (word_id => words.id)
#
require 'rails_helper'

RSpec.describe Morphology::Word, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
