class CreateMuhsafPages < ActiveRecord::Migration[6.1]
  def change
    ActiveRecord::Migration.create_table :mushaf_pages do |t|
      t.integer :page_number, index: true
      t.integer :mushaf_id, index: true

      t.json :verse_mapping
      t.integer :first_verse_id
      t.integer :last_verse_id
      t.integer :verses_count
      t.timestamps
    end
  end
end
