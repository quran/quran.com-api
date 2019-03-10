class CreateSlugs < ActiveRecord::Migration[5.2]
  def change
    create_table :slugs do |t|
      t.belongs_to :chapter
      t.string :slug
      t.string :locale
      t.timestamps
    end

    add_index :slugs, [:chapter_id, :slug]
  end
end
