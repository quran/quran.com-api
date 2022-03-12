class CreateQrPostFilters < ActiveRecord::Migration[7.0]
  def change
    create_table :qr_post_filters do |t|
      t.integer :post_id
      t.integer :filter_id

      t.timestamps
    end

    add_index :qr_post_filters, [:post_id, :filter_id]
  end
end
