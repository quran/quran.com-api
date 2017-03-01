class CreateWordRoots < ActiveRecord::Migration[5.0]
  def change
    create_table :word_roots do |t|
      t.references :word
      t.references :root

      t.timestamps
    end
  end
end
