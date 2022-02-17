class CreateRadioStations < ActiveRecord::Migration[6.1]
  def change
    create_table :radio_stations do |t|
      t.string :name
      t.string :cover_image
      t.string :profile_picture
      t.text :description
      t.integer :audio_recitation_id, index: true
      t.integer :parent_id, index: true
      t.integer :priority, index: true

      t.timestamps
    end

    create_table :radio_station_audio_files do |t|
      t.integer :radio_station_id
      t.integer :chapter_audio_file_id
      t.integer :chapter_id

      t.timestamps
    end

    add_index :radio_station_audio_files, [:radio_station_id, :chapter_audio_file_id, :chapter_id], name: 'index_on_radio_audio_files'

    add_column :reciters, :profile_picture, :string
    add_column :reciters, :cover_image, :string
    add_column :reciters, :bio, :text
  end
end