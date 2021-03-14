# frozen_string_literal: true

# == Schema Information
#
# Table name: resource_content_stats
#
#  id                  :integer          not null, primary key
#  download_count      :integer
#  platform            :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  resource_content_id :integer
#
# Indexes
#
#  index_resource_content_stats_on_platform             (platform)
#  index_resource_content_stats_on_resource_content_id  (resource_content_id)
#

class ResourceContentStat < ApplicationRecord
  include Resourceable
end
