class CreateNavigationSearchRecords < ActiveRecord::Migration[6.1]
  def change
    create_table :navigation_search_records do |t|
      t.string :result_type, index: true
      t.belongs_to :searchable_record, polymorphic: true
      t.string :name
      t.string :key
      t.string :text, index: true

      t.timestamps
    end

    add_column :slugs, :language_priority, :integer
    add_index :slugs, :language_priority

    add_column :slugs, :language_id, :integer
    add_index :slugs, :language_id
  end
end
