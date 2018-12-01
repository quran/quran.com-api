class ChangeJuzsToJson < ActiveRecord::Migration[5.0]
  def change
    add_column :juzs, :verse_mapping_json, :json
    Juz.all.each do |juz|
      juz.verse_mapping_json = juz.verse_mapping
      juz.save!
    end

    remove_column :juzs, :verse_mapping
    rename_column :juzs, :verse_mapping_json, :verse_mapping
  end
end


