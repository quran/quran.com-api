class CreateTranslations < ActiveRecord::Migration[5.0]
  def change
    create_table :translations do |t|
      t.references :language
      t.references :verse
      t.text :text
      t.references :resource_content
      t.string :language_name # cache
      t.integer :priority, index: true

      t.timestamps
    end
  end
end
