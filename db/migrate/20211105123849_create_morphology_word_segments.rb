class CreateMorphologyWordSegments < ActiveRecord::Migration[6.1]
  def change
    create_table :morphology_word_segments do |t|
      t.belongs_to :word, foreign_key: true
      t.belongs_to :root, foreign_key: true
      t.belongs_to :topic, foreign_key: true
      t.belongs_to :lemma, foreign_key: true # base word

      t.belongs_to :grammar_concept
      t.belongs_to :grammar_role
      t.belongs_to :grammar_sub_role
      t.belongs_to :grammar_term
      t.string :grammar_term_key # V, P, NP
      t.string :grammar_term_name

      t.string :part_of_speech_key, index: true # V, P, NP
      t.string :part_of_speech_name

      t.integer :position, index: true

      t.string :text_uthmani

      t.string :grammar_term_desc_english # corpus.quran.com
      t.string :grammar_term_desc_arabic #

      t.string :pos_tags, index: true # coming from quran-morphology.txt
      t.string :root_name          # cache root and lemma terms
      t.string :lemma_name
      t.string :verb_form

      t.timestamps
    end
  end
end
