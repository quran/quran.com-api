# == Schema Information
# Schema version: 20220109075422
#
# Table name: navigation_search_records
#
#  id                     :integer          not null, primary key
#  result_type            :string
#  searchable_record_type :string
#  searchable_record_id   :integer
#  name                   :string
#  key                    :string
#  text                   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_navigation_search_records_on_result_type        (result_type)
#  index_navigation_search_records_on_searchable_record  (searchable_record_type,searchable_record_id)
#  index_navigation_search_records_on_text               (text)
#

class NavigationSearchRecord < ApplicationRecord
  belongs_to :searchable_record, polymorphic: true
end
