class CreateWordStems < ActiveRecord::Migration[5.0]
  def change
    create_table :word_stems do |t|
      t.references :word, foreign_key: true
      t.references :stem, foreign_key: true

      t.timestamps
    end
  end
end
