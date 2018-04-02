class CreateTafsirs < ActiveRecord::Migration[5.0]
  def change
    create_table :tafsirs do |t|
      t.references :verse
      t.references :language
      t.text :text
      t.string :language_name # cache
      t.references :resource_content

      t.timestamps
    end
  end
end
