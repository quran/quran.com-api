class AddNastaleeqText < ActiveRecord::Migration[6.1]
  def change
    add_column :verses, :text_nastaleeq_indopak, :string
    add_column :words, :text_nastaleeq_indopak, :string
  end
end
