# == Schema Information
# Schema version: 20220123232023
#
# Table name: hizbs
#
#  id             :bigint           not null, primary key
#  hizb_number    :integer
#  verse_mapping  :jsonb
#  verses_count   :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  first_verse_id :integer
#  last_verse_id  :integer
#
# Indexes
#
#  index_hizbs_on_first_verse_id_and_last_verse_id  (first_verse_id,last_verse_id)
#  index_hizbs_on_hizb_number                       (hizb_number)
#

class Hizb < ApplicationRecord
end
