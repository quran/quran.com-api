class CreateAudioChangeLogs < ActiveRecord::Migration[6.1]
  def change
    create_table :audio_change_logs do |t|
      t.integer :audio_recitation_id
      t.datetime :date
      t.text :mini_desc
      t.text :rss_desc

      t.timestamps
    end
  end
end
