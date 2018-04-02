class CreateTransliterations < ActiveRecord::Migration[5.0]
  def change
    create_table :transliterations do |t|
      t.belongs_to :resource, polymorphic: true
      t.references :language

      t.text :text
      t.string :language_name # cache
      t.references :resource_content

      t.timestamps
    end
  end
end
