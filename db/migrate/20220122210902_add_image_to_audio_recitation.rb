class AddImageToAudioRecitation < ActiveRecord::Migration[6.1]
  def change
    add_column :reciters, :profile_picture, :string
    add_column :reciters, :cover_image, :string
    add_column :reciters, :bio, :text
  end
end