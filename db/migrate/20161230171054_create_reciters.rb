class CreateReciters < ActiveRecord::Migration[5.0]
  def change
    create_table :reciters do |t|
      t.string :name
      t.text :description
      t.integer :audio_recitations_count

      t.timestamps
    end
  end
end
