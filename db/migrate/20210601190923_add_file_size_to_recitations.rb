class AddFileSizeToRecitations < ActiveRecord::Migration[6.1]
  def change
    add_column :audio_recitations, :files_size, :integer
    add_column :audio_recitations, :approved, :boolean, default: false

    add_column :audio_recitations, :priority, :integer
    add_index :audio_recitations, :priority

    add_index :audio_recitations, :approved
    change_column :audio_chapter_audio_files, :file_size, :float

    rename_table :muhsaf_pages, :mushas_pages
  end
end
