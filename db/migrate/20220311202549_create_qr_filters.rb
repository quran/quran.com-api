class CreateQrFilters < ActiveRecord::Migration[7.0]
  def change
    create_table :qr_filters do |t|
      t.integer :book_id
      t.integer :topic_id

      t.integer :chapter_id, index: true
      t.integer :verse_number_from, index: true
      t.integer :verse_number_to, index: true
      t.string :verse_key_from
      t.string :verse_key_to
      t.integer :verse_id_from, index: true
      t.integer :verse_id_to, index: true

      t.timestamps
    end
  end
end
