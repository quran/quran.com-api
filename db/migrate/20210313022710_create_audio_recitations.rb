class CreateAudioRecitations < ActiveRecord::Migration[6.1]
  def change
    create_table :audio_recitations do |t|
      t.string :name
      t.string :arabic_name
      t.string :relative_path
      t.string :file_formats
      t.integer :section_id
      t.integer :home
      t.text :description
      t.string :torrent_filename
      t.string :torrent_info_hash
      t.integer :torrent_leechers, default: 0
      t.integer :torrent_seeders, default: 0

      t.timestamps
    end
  end
end
