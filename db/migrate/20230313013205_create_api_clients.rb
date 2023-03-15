class CreateApiClients < ActiveRecord::Migration[7.0]
  def change
    create_table :api_clients do |t|
      t.string :name
      t.string :api_key, index: true, null: false
      t.string :kalimat_api_key
      t.boolean :internal_api, default: false
      t.boolean :active, index: true, default: true

      t.integer :request_quota
      t.integer :requests_count

      t.integer :current_period_requests_count
      t.datetime :current_period_ends_at

      t.timestamps
    end
  end
end

