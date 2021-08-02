class CreateAudioSegments < ActiveRecord::Migration[6.1]
  def change
    # Store per ayah segments info of audio files
    create_table :audio_segments do |t|
      t.belongs_to :audio_file
      t.belongs_to :surah_recitation
      t.belongs_to :chapter, index: true
      t.belongs_to :verse, index: true

      t.integer :verse_number
      t.integer :start_timestamp, index: true # MS
      t.integer :end_timestamp, index: true # MS

      t.jsonb :segments, default: {}
      t.integer :duration # Seconds
      t.float :percentile # % of total audio file duration

      t.timestamps
    end

    add_index :audio_segments, [:audio_file_id, :verse_number]
  end
end
