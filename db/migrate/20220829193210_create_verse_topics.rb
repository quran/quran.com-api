class CreateVerseTopics < ActiveRecord::Migration[7.0]
  def change
    create_table :verse_topics do |t|
      t.integer :topic_id, index: true
      t.integer :verse_id, index: true
      t.jsonb :topic_words, default: []

      t.timestamps
    end
  end
end
