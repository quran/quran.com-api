class AddLanguagePriorityToTranslatedNames < ActiveRecord::Migration[5.0]
  def change
    add_column :translated_names, :language_priority, :integer
    add_index :translated_names, :language_priority

    add_column :translations, :language_priority, :integer
    add_index :translations, :language_priority
  end
end
