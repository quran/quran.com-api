class CreateMuhsafPages < ActiveRecord::Migration[6.1]
  def change
    create_table :mushaf_pages do |t|
      t.integer :page_number, index: true
      t.integer :mushaf_id, index: true
      t.integer :first_verse_id
      t.integer :last_verse_id
      t.integer :verses_count

      t.json :verse_mapping

      t.timestamps
    end
  end
end
