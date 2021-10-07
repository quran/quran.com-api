class AddMushafPagesToVerses < ActiveRecord::Migration[6.1]
  def change
    add_column :verses, :mushaf_pages_mapping, :jsonb, default: {}
  end
end
