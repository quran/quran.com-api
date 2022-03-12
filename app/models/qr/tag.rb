# == Schema Information
# Schema version: 20220310192026
#
# Table name: qr_tags
#
#  id         :bigint           not null, primary key
#  approved   :boolean          default(TRUE)
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_qr_tags_on_approved  (approved)
#  index_qr_tags_on_name      (name)
#
class Qr::Tag < QrRecord
  has_many :post_tags, class_name: 'Qr::PostTag'
  has_many :posts, through: :post_tags, class_name: 'Qr::Post'
end
