class CreateMorphologyDerivedWords < ActiveRecord::Migration[6.1]
  def change
    create_table :morphology_derived_words do |t|
      t.belongs_to :verse, foreign_key: true
      t.belongs_to :word, foreign_key: true
      t.belongs_to :derived_word
      t.belongs_to :word_verb_from
      t.string :form_name
      t.string :en_transliteration
      t.string :en_translation

      t.timestamps
    end
  end
end
