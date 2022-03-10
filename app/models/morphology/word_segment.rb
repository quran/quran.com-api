# == Schema Information
# Schema version: 20220123232023
#
# Table name: morphology_word_segments
#
#  id                        :bigint           not null, primary key
#  grammar_term_desc_arabic  :string
#  grammar_term_desc_english :string
#  grammar_term_key          :string
#  grammar_term_name         :string
#  hidden                    :boolean
#  lemma_name                :string
#  part_of_speech_key        :string
#  part_of_speech_name       :string
#  pos_tags                  :string
#  position                  :integer
#  root_name                 :string
#  text_uthmani              :string
#  verb_form                 :string
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  grammar_concept_id        :bigint
#  grammar_role_id           :bigint
#  grammar_sub_role_id       :bigint
#  grammar_term_id           :bigint
#  lemma_id                  :bigint
#  root_id                   :bigint
#  topic_id                  :bigint
#  word_id                   :bigint
#
# Indexes
#
#  index_morphology_word_segments_on_grammar_concept_id   (grammar_concept_id)
#  index_morphology_word_segments_on_grammar_role_id      (grammar_role_id)
#  index_morphology_word_segments_on_grammar_sub_role_id  (grammar_sub_role_id)
#  index_morphology_word_segments_on_grammar_term_id      (grammar_term_id)
#  index_morphology_word_segments_on_lemma_id             (lemma_id)
#  index_morphology_word_segments_on_part_of_speech_key   (part_of_speech_key)
#  index_morphology_word_segments_on_pos_tags             (pos_tags)
#  index_morphology_word_segments_on_position             (position)
#  index_morphology_word_segments_on_root_id              (root_id)
#  index_morphology_word_segments_on_topic_id             (topic_id)
#  index_morphology_word_segments_on_word_id              (word_id)
#
# Foreign Keys
#
#  fk_rails_18c40a6302  (word_id => words.id)
#  fk_rails_378c14d9b9  (root_id => roots.id)
#  fk_rails_3887db9336  (topic_id => topics.id)
#  fk_rails_a3cf985389  (lemma_id => lemmas.id)
#

class Morphology::WordSegment < ApplicationRecord
  belongs_to :word, class_name: 'Morphology::Word'
  belongs_to :grammar_concept, class_name: 'Morphology::GrammarConcept', optional: true
  belongs_to :grammar_role, class_name: 'Morphology::GrammarConcept', optional: true
  belongs_to :grammar_sub_role, class_name: 'Morphology::GrammarConcept', optional: true
  belongs_to :grammar_term, class_name: 'Morphology::GrammarTerm', optional: true

  belongs_to :root, optional: true
  belongs_to :topic, optional: true
  belongs_to :lemma, optional: true
end
