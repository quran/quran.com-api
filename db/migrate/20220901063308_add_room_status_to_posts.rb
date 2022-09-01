class AddRoomStatusToPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :qr_posts, :room_post_status, :integer
    add_index :qr_posts, :room_post_status
  end
end
