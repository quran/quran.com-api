class AddTopicFields < ActiveRecord::Migration[7.0]
  def change
    add_column :topics, :wikipedia_link, :string
    add_column :topics, :arabic_name, :string
    add_column :topics, :ontology, :boolean
    add_column :topics, :thematic, :boolean

    add_column :topics, :depth, :integer, default: 0
    add_column :topics, :ayah_range, :string
    add_column :topics, :relatd_topics_count, :integer, default: 0
    add_column :topics, :childen_count, :integer, default: 0
    add_column :topics, :description, :text
    add_column :topics, :ontology_parent_id, :integer
    add_column :topics, :thematic_parent_id, :integer

    add_index :topics, :depth
    add_index :topics, :name
    add_index :topics, :ontology_parent_id
    add_index :topics, :thematic_parent_id
    add_index :topics, :ontology
    add_index :topics, :thematic
  end
end
