class CreateAudioSegments < ActiveRecord::Migration[6.1]
  def change
    # Store per ayah segments info of audio files
    create_table :audio_segments do |t|
      t.belongs_to :audio_file
      t.belongs_to :audio_recitation
      t.belongs_to :chapter
      t.belongs_to :verse

      t.string :verse_key
      t.integer :verse_number, index: true
      t.integer :timestamp_from # MS
      t.integer :timestamp_to # MS
      t.integer :timestamp_median # MS

      t.jsonb :segments, default: []
      t.integer :duration # Seconds
      t.integer :duration_ms
      t.float :percentile # % of total audio file duration

      t.timestamps
    end

    add_index :audio_segments, [:audio_file_id, :timestamp_median], unique: true
    add_index :audio_segments, [:audio_file_id, :verse_number], unique: true
    add_index :audio_segments, [:audio_recitation_id, :chapter_id, :verse_id, :timestamp_median], name: 'index_on_audio_segments_median_time'
  end
end