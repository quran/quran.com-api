class AddKfqcUthmaniHafs < ActiveRecord::Migration[6.1]
  def change
    # New and improve Indopak script
    add_column :verses, :text_indopak_nastaleeq, :string
    add_column :words, :text_indopak_nastaleeq, :string

    #  QPC nastaleeq text but modified to make it compatible with indopak nastaleeq font
    add_column :verses, :text_qpc_nastaleeq, :string
    add_column :words, :text_qpc_nastaleeq, :string

    # Indopak nastaleeq text from QPC compatible with their own font
    add_column :verses, :text_qpc_nastaleeq_hafs, :string
    add_column :words, :text_qpc_nastaleeq_hafs, :string
  end
end