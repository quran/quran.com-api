class CreateVerses < ActiveRecord::Migration[5.0]
  def change
    create_table :verses do |t|
      t.references :chapter
      t.integer :verse_number, index: true
      t.integer :verse_index, index: true
      t.string :verse_key, index: true

      t.text :text_madani
      t.text :text_indopak
      t.text :text_simple
      t.text :text_root
      t.text :text_stem
      t.text :text_token
      t.text :text_lemma

      t.integer :juz_number
      t.integer :hizb_number
      t.integer :rub_number
      t.string :sajdah
      t.integer :sajdah_number
      t.integer :page_number
      t.string :image_url

      t.timestamps
    end
  end
end
