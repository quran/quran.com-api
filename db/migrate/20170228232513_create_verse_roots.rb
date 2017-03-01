class CreateVerseRoots < ActiveRecord::Migration[5.0]
  def change
    create_table :verse_roots do |t|
      t.text :value

      t.timestamps
    end

    add_column :verses, :verse_root_id, :integer
    add_index :verses, :verse_root_id
  end
end
