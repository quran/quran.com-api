class CreateWordTopics < ActiveRecord::Migration[5.0]
  def change
    create_table :word_topics do |t|
      t.references :word
      t.references :topic

      t.timestamps
    end
  end
end
