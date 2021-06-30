class CreateAudioSegments < ActiveRecord::Migration[6.1]
  def change
    create_table :audio_segments do |t|

      t.timestamps
    end
  end
end
