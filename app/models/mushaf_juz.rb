# == Schema Information
# Schema version: 20220723001532
#
# Table name: mushaf_juzs
#
#  id             :bigint           not null, primary key
#  juz_number     :integer
#  mushaf_type    :integer
#  verse_mapping  :jsonb
#  verses_count   :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  first_verse_id :integer
#  juz_id         :integer
#  last_verse_id  :integer
#  mushaf_id      :integer
#
# Indexes
#
#  index_mushaf_juzs_on_first_verse_id  (first_verse_id)
#  index_mushaf_juzs_on_juz_id          (juz_id)
#  index_mushaf_juzs_on_juz_number      (juz_number)
#  index_mushaf_juzs_on_last_verse_id   (last_verse_id)
#  index_mushaf_juzs_on_mushaf_id       (mushaf_id)
#  index_mushaf_juzs_on_mushaf_type     (mushaf_type)
#
class MushafJuz < ApplicationRecord
  belongs_to :mushaf
  belongs_to :juz
  belongs_to :first_verse, class_name: 'Verse'
  belongs_to :last_verse, class_name: 'Verse'

  enum mushaf_type: {
    madani: 1,
    indopak: 2
  }

  def verses
    Verse.where("id BETWEEN :from AND :to", from: first_verse_id, to: last_verse_id)
  end
end
