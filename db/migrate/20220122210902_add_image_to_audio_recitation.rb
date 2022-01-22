class AddImageToAudioRecitation < ActiveRecord::Migration[6.1]
  def change
    add_column :reciters, :image_path, :string
    add_column :reciters, :bio, :text
  end
end
