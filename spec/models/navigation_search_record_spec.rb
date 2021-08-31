# == Schema Information
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
require 'rails_helper'

RSpec.describe NavigationSearchRecord, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
