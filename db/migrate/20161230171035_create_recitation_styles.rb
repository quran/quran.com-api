class CreateRecitationStyles < ActiveRecord::Migration[5.0]
  def change
    create_table :recitation_styles do |t|
      t.string :style
      t.text :description
      t.string :arabic
      t.string :slug, index: true
      t.integer :audio_recitations_count

      t.timestamps
    end
  end
end