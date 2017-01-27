class CreateAudioFiles < ActiveRecord::Migration[5.0]
  def change
    create_table :audio_files do |t|
      t.belongs_to :resource, polymorphic: true
      t.text :url
      t.integer :duration
      t.text :segments
      t.string :mime_type
      t.string :format
      t.boolean :is_enabled, index: true
      t.references :recitation

      t.timestamps
    end
  end
end
