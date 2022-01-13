# == Schema Information
#
# Table name: manzils
#
#  id             :bigint           not null, primary key
#  manzil_number  :integer
#  verse_mapping  :json
#  verses_count   :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  first_verse_id :integer
#  last_verse_id  :integer
#
# Indexes
#
#  index_manzils_on_first_verse_id_and_last_verse_id  (first_verse_id,last_verse_id)
#  index_manzils_on_manzil_number                     (manzil_number)
#
class Manzil < ApplicationRecord
end
