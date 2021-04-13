class CreateAudioSections < ActiveRecord::Migration[6.1]
  def change
    create_table :audio_sections do |t|
      t.string :name

      t.timestamps
    end
  end
end
