class CreateQrPosts < ActiveRecord::Migration[7.0]
  def change
    create_table :qr_posts do |t|
      t.integer :post_type, index: true
      t.integer :author_id, index: true
      t.boolean :verified, index: true

      t.integer :likes_count, default: 0
      t.integer :comments_count, default: 0
      t.integer :views_count, default: 0
      t.integer :language_id, index: true
      t.string :language_name

      t.text :body
      t.text :html_body

      t.timestamps
    end
  end
end