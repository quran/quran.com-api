class CreateResourceContents < ActiveRecord::Migration[5.0]
  def change
    create_table :resource_contents do |t|
      t.boolean :approved, index: true
      t.references :author
      t.references :data_source
      t.string :author_name # avoid extra join

      t.string :resource_type, index: true
      t.string :sub_type, index: true
      t.string :name
      t.integer :mobile_translation_id, index: true # mobile app has different ids for translation. Need this for backword compatibility

      t.text :description
      t.string :cardinality_type, index: true
      t.references :language
      t.string :language_name # cache

      t.timestamps
    end
  end
end