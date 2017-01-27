class CreateDataSources < ActiveRecord::Migration[5.0]
  def change
    create_table :data_sources do |t|
      t.string :name
      t.string :url

      t.timestamps
    end
  end
end
