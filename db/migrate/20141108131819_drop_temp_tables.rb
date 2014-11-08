class DropTempTables < ActiveRecord::Migration
  def change
      drop_table :in_author
      drop_table :in_source
      drop_table :in_resource_api_version
      drop_table :in_transliteration
      drop_table :in_translation
      drop_table :in_tafsir_ayah
      drop_table :in_tafsir
      drop_table :in_resource
  end
end
