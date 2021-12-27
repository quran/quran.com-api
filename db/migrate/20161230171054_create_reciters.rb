class CreateReciters < ActiveRecord::Migration[5.0]
  def change
    create_table :reciters do |t|
      t.string :name
      t.text :description
      t.integer :recitations_count, default: 0

      t.timestamps
    end
  end
end
