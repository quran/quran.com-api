class CreateQrPostTags < ActiveRecord::Migration[7.0]
  def change
    create_table :qr_post_tags do |t|
      t.integer :post_id
      t.integer :tag_id

      t.timestamps
    end

    add_index :qr_post_tags, [:post_id, :tag_id]
  end
end
