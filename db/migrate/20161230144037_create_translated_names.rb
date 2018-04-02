class CreateTranslatedNames < ActiveRecord::Migration[5.0]
  def change
    create_table :translated_names do |t|
      t.belongs_to :resource, polymorphic: true
      t.references :language

      t.string :name
      t.string :language_name # cache

      t.timestamps
    end
  end
end
