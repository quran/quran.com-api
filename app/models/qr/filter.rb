# == Schema Information
# Schema version: 20220311202850
#
# Table name: qr_filters
#
#  id         :bigint           not null, primary key
#  from       :string
#  to         :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  book_id    :string
#  chapter_id :string
#  topic_id   :string
#
class Qr::Filter < QrRecord
  has_many :post_filters, class_name: 'Qr::PostFilter'
  has_many :posts, through: :post_filters, class_name: 'Qr::Post'
end
