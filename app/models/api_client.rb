# == Schema Information
# Schema version: 20230313013539
#
# Table name: api_clients
#
#  id                            :bigint           not null, primary key
#  active                        :boolean          default(TRUE)
#  api_key                       :string           not null
#  current_period_ends_at        :datetime
#  current_period_requests_count :integer
#  name                          :string
#  requests_count                :integer
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#
# Indexes
#
#  index_api_clients_on_active   (active)
#  index_api_clients_on_api_key  (api_key)
#
class ApiClient < ApplicationRecord
  kredis_hash :requests

  def rate_limited?
    return false if internal_api?

    current_period_requests_count.to_i > request_quota.to_i
  end

  def track_api_call(query:)
    list = Kredis.list("api_client:#{id}-requests")
    list.append(Oj.dump({ query: query, timestamp: Time.now.to_i }))
  end
end
