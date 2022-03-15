class CreateQrAuthors < ActiveRecord::Migration[7.0]
  def change
    create_table :qr_authors do |t|
      t.string :name
      t.string :username, index: true
      t.boolean :verified, index: true
      t.string :avatar_url
      t.text :bio

      t.integer :user_type, index: true
      t.integer :followers_count, default: 0
      t.integer :followings_count, default: 0
      t.integer :posts_count, default: 0
      t.integer :comments_count, default: 0

      t.timestamps
    end
  end
end