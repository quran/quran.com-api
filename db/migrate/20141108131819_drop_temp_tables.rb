class DropTempTables < ActiveRecord::Migration
  def change 
    tables = [:in_author, :in_source, :in_resource_api_version, :in_transliteration, :in_translation, :in_tafsir_ayah, :in_tafsir, :in_resource]
    tables.each do |table|
      if ActiveRecord::Base.connection.table_exists? table
          drop_table table
      end
    end
  end
end
