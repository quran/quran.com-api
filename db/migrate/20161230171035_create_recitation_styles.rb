class CreateRecitationStyles < ActiveRecord::Migration[5.0]
  def change
    create_table :recitation_styles do |t|
      t.string :style

      t.timestamps
    end
  end
end
