class CreateTranslations < ActiveRecord::Migration[5.0]
  def change
    create_table :translations do |t|
      t.references :language
      t.string :text
      t.references :resource_content
      t.belongs_to :resource, polymorphic: true, index: true
      t.string :language_name # cache

      t.timestamps
    end
  end
end
