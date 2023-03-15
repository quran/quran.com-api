# == Schema Information
# Schema version: 20230313013539
#
# Table name: api_client_request_stats
#
#  id             :bigint           not null, primary key
#  date           :date
#  requests_count :integer          default(0)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  api_client_id  :integer
#
# Indexes
#
#  index_api_client_request_stats_on_api_client_id  (api_client_id)
#  index_api_client_request_stats_on_date           (date)
#
class ApiClientRequestStat < ApplicationRecord
end
