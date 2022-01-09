class AddKfqcUthmaniHafs < ActiveRecord::Migration[6.1]
  def change
    add_column :words, :text_qpc_nastaleeq, :string
    add_column :words, :text_qpc_hafs, :string
    add_column :verses, :text_qpc_nastaleeq, :string
    add_column :verses, :text_qpc_hafs, :string
  end
end
