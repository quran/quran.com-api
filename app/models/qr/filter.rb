# == Schema Information
# Schema version: 20220311202850
#
# Table name: qr_filters
#
#  id                :bigint           not null, primary key
#  verse_id_from     :integer
#  verse_id_to       :integer
#  verse_key_from    :string
#  verse_key_to      :string
#  verse_number_from :integer
#  verse_number_to   :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  book_id           :integer
#  chapter_id        :integer
#  topic_id          :integer
#
# Indexes
#
#  index_qr_filters_on_chapter_id         (chapter_id)
#  index_qr_filters_on_verse_id_from      (verse_id_from)
#  index_qr_filters_on_verse_id_to        (verse_id_to)
#  index_qr_filters_on_verse_number_from  (verse_number_from)
#  index_qr_filters_on_verse_number_to    (verse_number_to)
#
class Qr::Filter < QrRecord
  has_many :post_filters, class_name: 'Qr::PostFilter'
  has_many :posts, through: :post_filters, class_name: 'Qr::Post'
end
