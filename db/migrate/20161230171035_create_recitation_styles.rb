class CreateRecitationStyles < ActiveRecord::Migration[5.0]
  def change
    create_table :recitation_styles do |t|
      t.string :name
      t.text :description
      t.string :arabic
      t.string :slug, index: true
      t.integer :recitations_count, default: 0

      t.timestamps
    end
  end
end