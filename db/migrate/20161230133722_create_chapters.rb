class CreateChapters < ActiveRecord::Migration[5.0]
  def change
    create_table :chapters do |t|
      t.boolean :bismillah_pre
      t.integer :revelation_order
      t.string :revelation_place
      t.string :name_complex
      t.string :name_arabic
      t.string :name_simple
      t.string :pages
      t.integer :verses_count
      t.integer :chapter_number, index: true

      t.timestamps
    end
  end
end
