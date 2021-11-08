class CreateMorphologyWordVerbForms < ActiveRecord::Migration[6.1]
  def change
    create_table :morphology_word_verb_forms do |t|
      t.belongs_to :word, foreign_key: true
      t.string :name, index: true
      t.string :value

      t.timestamps
    end
  end
end
