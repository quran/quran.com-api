class CreateVerseStems < ActiveRecord::Migration[5.0]
  def change
    create_table :verse_stems do |t|
      t.string :text_madani
      t.string :text_clean

      t.timestamps
    end

    add_column :verses, :verse_stem_id, :integer
    add_index :verses, :verse_stem_id
  end
end
