class CreateAudioRecitations < ActiveRecord::Migration[6.1]
  def change
    create_table :audio_recitations do |t|
      t.string :name, index: true
      t.string :arabic_name
      t.string :relative_path, index: true
      t.string :format
      t.integer :section_id, index: true
      t.text :description
      t.integer :files_count
      t.integer :priority, index: true

      t.integer :resource_content_id, index: true
      t.integer :recitation_style_id, index: true
      t.integer :reciter_id, index: true
      t.boolean :approved, index: true
      t.boolean :lock_segments, default: false
      t.integer :segment_locked
      t.integer :files_size
      t.integer :home
      t.integer :qirat_type_id

      t.timestamps
    end
  end
end