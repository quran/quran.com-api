class CreateAudioSegments < ActiveRecord::Migration[6.1]
  def change
    # Store per ayah segments info of audio files
    create_table :audio_segments do |t|
      t.belongs_to :audio_file
      t.belongs_to :surah_recitation
      t.belongs_to :chapter
      t.belongs_to :verse

      t.string :verse_key
      t.integer :verse_number
      t.integer :start_timestamp # MS
      t.integer :end_timestamp # MS

      t.jsonb :segments, default: []
      t.integer :duration # Seconds
      t.float :percentile # % of total audio file duration

      t.timestamps
    end

    add_index :audio_segments, [:audio_file_id, :start_timestamp, :end_timestamp, :verse_number], name: 'index_on_audio_segments_timing'
    add_index :audio_segments, [:surah_recitation_id, :chapter_id, :verse_id, :start_timestamp, :end_timestamp], name: 'index_on_audio_segments_chapter'
  end
end