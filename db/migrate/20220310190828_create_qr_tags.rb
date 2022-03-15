class CreateQrTags < ActiveRecord::Migration[7.0]
  def change
    create_table :qr_tags do |t|
      t.string :name
      t.boolean :approved, default: true
      t.integer :posts_count, index: true
      t.integer :comments_count

      t.timestamps
    end

    add_index :qr_tags, :name
    add_index :qr_tags, :approved
  end
end