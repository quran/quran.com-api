class CreateLanguages < ActiveRecord::Migration[5.0]
  def change
    create_table :languages do |t|
      t.string :name
      t.string :iso_code, index: true
      t.string :native_name
      t.string :direction
      t.string :es_analyzer_default

      t.timestamps
    end
  end
end
