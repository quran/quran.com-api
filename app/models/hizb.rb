# == Schema Information
# Schema version: 20220109075422
#
# Table name: hizbs
#
#  id             :integer          not null, primary key
#  hizb_number    :integer
#  verses_count   :integer
#  verse_mapping  :jsonb
#  first_verse_id :integer
#  last_verse_id  :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_hizbs_on_first_verse_id_and_last_verse_id  (first_verse_id,last_verse_id)
#  index_hizbs_on_hizb_number                       (hizb_number)
#

class Hizb < ApplicationRecord
end
