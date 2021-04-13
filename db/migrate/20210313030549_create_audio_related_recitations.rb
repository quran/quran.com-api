class CreateAudioRelatedRecitations < ActiveRecord::Migration[6.1]
  def change
    create_table :audio_related_recitations do |t|
      t.integer :audio_recitation_id
      t.integer :related_audio_recitation_id

      t.timestamps
    end

    add_index :audio_related_recitations, [:audio_recitation_id, :related_audio_recitation_id], name: 'index_audio_related_recitation'
  end
end
