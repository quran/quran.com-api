# == Schema Information
# Schema version: 20220311202850
#
# Table name: qr_posts
#
#  id             :bigint           not null, primary key
#  body           :text
#  comments_count :integer          default(0)
#  html_body      :text
#  language_name  :string
#  likes_count    :integer          default(0)
#  post_type      :integer
#  verified       :boolean
#  views_count    :integer          default(0)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  author_id      :integer
#  language_id    :integer
#
# Indexes
#
#  index_qr_posts_on_author_id    (author_id)
#  index_qr_posts_on_language_id  (language_id)
#  index_qr_posts_on_post_type    (post_type)
#  index_qr_posts_on_verified     (verified)
#
class Qr::Post < QrRecord
  belongs_to :author, class_name: 'Qr::Author'

  has_many :post_filters, class_name: 'Qr::PostFilter'
  has_many :filters, through: :post_filters, class_name: 'Qr::Filter'
  has_many :post_tags, class_name: 'Qr::PostTag'
  has_many :tags, through: :post_tags, class_name: 'Qr::Tag'
  has_many :comments, class_name: 'Qr::Comment'
  has_many :recent_comments, -> {order('created_at DESC').limit(10)}, class_name: 'Qr::Comment'
end
