class CreateQrRooms < ActiveRecord::Migration[7.0]
  def change
    create_table :qr_rooms do |t|
      t.string :name
      t.string :subdomain

      t.timestamps
    end

    add_column :qr_posts, :room_id, :integer
  end
end
