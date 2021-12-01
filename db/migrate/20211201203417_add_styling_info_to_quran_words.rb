class AddStylingInfoToQuranWords < ActiveRecord::Migration[6.1]
  def change
    add_column :mushaf_words, :css_style, :string
    add_column :mushaf_words, :css_class, :string
  end
end
