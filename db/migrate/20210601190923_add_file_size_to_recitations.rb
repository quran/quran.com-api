class AddFileSizeToRecitations < ActiveRecord::Migration[6.1]
  def change
    add_column :audio_recitations, :files_size, :integer
    add_column :audio_recitations, :active, :boolean, default: false
    add_index :audio_recitations, :active
    change_column :audio_chapter_audio_files, :file_size, :float
  end
end
