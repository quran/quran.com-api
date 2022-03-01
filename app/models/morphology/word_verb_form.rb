# == Schema Information
# Schema version: 20220109075422
#
# Table name: morphology_word_verb_forms
#
#  id         :integer          not null, primary key
#  word_id    :integer
#  name       :string
#  value      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_morphology_word_verb_forms_on_name     (name)
#  index_morphology_word_verb_forms_on_word_id  (word_id)
#

class Morphology::WordVerbForm < ApplicationRecord
  belongs_to :word, class_name: 'Morphology::Word'
end
