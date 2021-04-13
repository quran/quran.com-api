class CreateAudioChapterAudioFiles < ActiveRecord::Migration[6.1]
  def change
    create_table :audio_chapter_audio_files do |t|
      t.integer :chapter_id, index: true
      t.integer :audio_recitation_id, index: true
      t.integer :total_files
      t.integer :stream_count
      t.integer :download_count
      t.integer :file_size
      t.integer :bit_rate
      t.integer :duration

      t.string :file_name
      t.string :format, index: true  # file extension
      t.string :mime_type

      t.jsonb :metadata, default: {}

      t.timestamps
    end
  end
end