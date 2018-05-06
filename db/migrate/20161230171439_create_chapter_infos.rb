class CreateChapterInfos < ActiveRecord::Migration[5.0]
  def change
    create_table :chapter_infos do |t|
      t.references :chapter
      t.text :text
      t.string :source
      t.text :short_text
      t.references :language
      t.references :resource_content
      t.string :language_name # cache

      t.timestamps
    end
  end
end
