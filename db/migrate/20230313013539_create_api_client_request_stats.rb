class CreateApiClientRequestStats < ActiveRecord::Migration[7.0]
  def change
    create_table :api_client_request_stats do |t|
      t.integer :api_client_id, index: true
      t.date :date, index: true
      t.integer :requests_count, default: 0

      t.timestamps
    end
  end
end
