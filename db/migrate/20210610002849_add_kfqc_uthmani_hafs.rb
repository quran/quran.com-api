class AddKfqcUthmaniHafs < ActiveRecord::Migration[6.1]
  def change
    add_column :words, :qpc_uthmani_hafs, :string
    add_column :words, :qpc_uthmani_qaloon, :string
    add_column :words, :qpc_uthmani_shouba, :string
    add_column :words, :qpc_uthmani_warsh, :string
    add_column :words, :qpc_uthmani_doori, :string
    add_column :words, :qpc_uthmani_qumbul, :string
    add_column :words, :qpc_uthmani_bazzi, :string
    add_column :words, :qpc_uthmani_soosi, :string

    add_column :verses, :qpc_uthmani_hafs, :string
    add_column :verses, :qpc_uthmani_qaloon, :string
    add_column :verses, :qpc_uthmani_shouba, :string
    add_column :verses, :qpc_uthmani_warsh, :string
    add_column :verses, :qpc_uthmani_doori, :string
    add_column :verses, :qpc_uthmani_qumbul, :string
    add_column :verses, :qpc_uthmani_bazzi, :string
    add_column :verses, :qpc_uthmani_soosi, :string
  end
end
