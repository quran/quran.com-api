class CreateQrReportedIssues < ActiveRecord::Migration[7.0]
  def change
    create_table :qr_reported_issues do |t|
      t.integer :post_id
      t.integer :comment_id
      t.string :name
      t.string :email
      t.text :body
      t.boolean :synced_with_qr, default: false

      t.timestamps
    end
  end
end
