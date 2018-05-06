class CreateMediaContents < ActiveRecord::Migration[5.0]
  def change
    create_table :media_contents do |t|
      t.belongs_to :resource, polymorphic: true
      t.text :url
      t.string :duration
      t.text :embed_text
      t.string :provider
      t.references :language
      t.string :language_name # cache
      t.string :author_name # cache
      t.references :resource_content

      t.timestamps
    end
  end
end
