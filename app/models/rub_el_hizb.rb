# == Schema Information
# Schema version: 20220109075422
#
# Table name: rub_el_hizbs
#
#  id                 :integer          not null, primary key
#  rub_el_hizb_number :integer
#  verses_count       :integer
#  verse_mapping      :json
#  first_verse_id     :integer
#  last_verse_id      :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_rub_el_hizbs_on_first_verse_id_and_last_verse_id  (first_verse_id,last_verse_id)
#  index_rub_el_hizbs_on_rub_el_hizb_number                (rub_el_hizb_number)
#

class RubElHizb < ApplicationRecord
end
