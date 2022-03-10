# == Schema Information
# Schema version: 20220123232023
#
# Table name: navigation_search_records
#
#  id                     :bigint           not null, primary key
#  key                    :string
#  name                   :string
#  result_type            :string
#  searchable_record_type :string
#  text                   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  searchable_record_id   :bigint
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
