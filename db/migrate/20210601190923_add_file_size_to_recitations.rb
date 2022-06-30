class AddFileSizeToRecitations < ActiveRecord::Migration[6.1]
  def change
    change_column :audio_recitations, :files_size, :float
    change_column :audio_recitations, :approved, :boolean, default: false

    change_column :audio_recitations, :priority, :integer, index: true

    change_column :audio_chapter_audio_files, :file_size, :float
  end
end
