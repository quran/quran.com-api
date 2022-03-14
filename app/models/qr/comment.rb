# == Schema Information
# Schema version: 20220311202850
#
# Table name: qr_comments
#
#  id            :bigint           not null, primary key
#  body          :text
#  html_body     :text
#  replies_count :integer          default(0)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  author_id     :integer
#  parent_id     :integer
#  post_id       :integer
#
# Indexes
#
#  index_qr_comments_on_author_id  (author_id)
#  index_qr_comments_on_parent_id  (parent_id)
#  index_qr_comments_on_post_id    (post_id)
#

class Qr::Comment < QrRecord
  belongs_to :author, class_name: 'Qr::Author', counter_cache: true
  belongs_to :post, class_name: 'Qr::Post', optional: true, counter_cache: true
  belongs_to :parent, counter_cache: :replies_count, optional: true, class_name: 'Qr::Comment'

  has_many :replies, class_name: 'Qr::Comment', foreign_key: :parent_id
  has_many :recent_replies, -> {order('qr_comments.created_at DESC').limit(10)}, class_name: 'Qr::Comment', foreign_key: :parent_id
end
