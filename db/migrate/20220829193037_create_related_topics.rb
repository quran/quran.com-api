class CreateRelatedTopics < ActiveRecord::Migration[7.0]
  def change
    create_table :related_topics do |t|
      t.integer :topic_id, index: true
      t.integer :related_topic_id

      t.timestamps
    end
  end
end
