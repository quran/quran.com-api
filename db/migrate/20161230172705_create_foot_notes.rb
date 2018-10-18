class CreateFootNotes < ActiveRecord::Migration[5.0]
  def change
    create_table :foot_notes do |t|
      t.belongs_to :resource, polymorphic: true
      t.text :text
      t.references :language
      t.string :language_name # cache
      t.references :resource_content

      t.timestamps
    end
  end
end
