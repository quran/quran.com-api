class CreateArabicTransliterations < ActiveRecord::Migration[5.0]
  def change
=begin
    create_table :arabic_transliterations do |t|
      t.belongs_to :word, index: true
      t.belongs_to :verse, index: true
      t.string :text
      t.string :indopak_text
      t.integer :page_number
      t.string :ur_translation
      t.integer :position_x
      t.integer :position_y
      t.integer :zoom

      t.timestamps
    end
=end
  end
end
