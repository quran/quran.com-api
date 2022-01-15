# == Schema Information
# Schema version: 20220109075422
#
# Table name: morphology_word_segments
#
#  id                        :integer          not null, primary key
#  word_id                   :integer
#  root_id                   :integer
#  topic_id                  :integer
#  lemma_id                  :integer
#  grammar_concept_id        :integer
#  grammar_role_id           :integer
#  grammar_sub_role_id       :integer
#  grammar_term_id           :integer
#  grammar_term_key          :string
#  grammar_term_name         :string
#  part_of_speech_key        :string
#  part_of_speech_name       :string
#  position                  :integer
#  text_uthmani              :string
#  grammar_term_desc_english :string
#  grammar_term_desc_arabic  :string
#  pos_tags                  :string
#  root_name                 :string
#  lemma_name                :string
#  verb_form                 :string
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  hidden                    :boolean
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
