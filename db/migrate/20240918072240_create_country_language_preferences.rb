class CreateCountryLanguagePreferences < ActiveRecord::Migration[7.0]
  def change
    create_table :country_language_preferences do |t|
      t.string :country, null: true
      t.string :user_device_language, null: false
      t.integer :default_mushaf_id
      t.string :default_translation_ids
      t.integer :default_tafsir_id
      t.string :default_wbw_language
      t.integer :default_reciter
      t.string :ayah_reflections_languages
      t.string :learning_plan_languages

      t.timestamps
    end

    add_foreign_key :country_language_preferences, :languages, column: :user_device_language, primary_key: :iso_code, on_delete: :cascade
    add_foreign_key :country_language_preferences, :mushafs, column: :default_mushaf_id, on_delete: :cascade
    add_foreign_key :country_language_preferences, :resource_contents, column: :default_tafsir_id, on_delete: :cascade
    add_foreign_key :country_language_preferences, :languages, column: :default_wbw_language, primary_key: :iso_code, on_delete: :cascade
    add_foreign_key :country_language_preferences, :reciters, column: :default_reciter, on_delete: :cascade
  end
end
