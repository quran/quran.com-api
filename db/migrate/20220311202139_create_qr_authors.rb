class CreateQrAuthors < ActiveRecord::Migration[7.0]
  def change
    create_table :qr_authors do |t|
      t.string :name
      t.string :username, index: true
      t.boolean :verified, index: true
      t.string :avatar_url
      t.text :bio
      t.integer :user_type, index: true
      t.integer :followers_count
      t.integer :followings_count

      t.timestamps
    end
  end
end