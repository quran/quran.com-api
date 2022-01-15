# == Schema Information
# Schema version: 20220109075422
#
# Table name: manzils
#
#  id             :integer          not null, primary key
#  manzil_number  :integer
#  verses_count   :integer
#  verse_mapping  :json
#  first_verse_id :integer
#  last_verse_id  :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_manzils_on_first_verse_id_and_last_verse_id  (first_verse_id,last_verse_id)
#  index_manzils_on_manzil_number                     (manzil_number)
#

class Manzil < ApplicationRecord
end
