class AddTextToTokens < ActiveRecord::Migration[6.1]
  def change
    add_column :tokens, :text, :text
    add_column :tokens, :resource_content_id, :integer
    add_column :tokens, :record_id, :integer
    add_column :tokens, :record_type, :string
    add_column :tokens, :uniq_token_count, :integer

    add_index :tokens, :text
    add_index :tokens, :resource_content_id
    add_index :tokens, [:record_type, :record_id]
  end
end
