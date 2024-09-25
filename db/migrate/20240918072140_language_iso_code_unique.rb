class LanguageIsoCodeUnique < ActiveRecord::Migration[7.0]
  def change
    remove_index :languages, :iso_code if index_exists?(:languages, :iso_code)
    add_index :languages, :iso_code, unique: true
  end
end
