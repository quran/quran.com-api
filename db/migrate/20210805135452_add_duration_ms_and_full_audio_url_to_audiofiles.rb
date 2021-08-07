class AddDurationMsAndFullAudioUrlToAudiofiles < ActiveRecord::Migration[6.1]
  def change
    add_column :audio_chapter_audio_files, :duration_ms, :integer
    add_column :audio_chapter_audio_files, :audio_url, :string
    add_column :slugs, :name, :string
  end
end
